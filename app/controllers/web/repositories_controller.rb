module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories.includes(:checks).order(id: :desc)
    end

    def show
      @repository = current_user.repositories.find(params[:id])
      @checks = @repository.checks.order(id: :desc)
    end

    def new
      @repository = current_user.repositories.build
      @github_repositories = available_github_repositories
    end

    def create
      github_id = params.require(:repository).fetch(:github_id).to_i

      if current_user.repositories.exists?(github_id: github_id)
        redirect_to repositories_path, notice: t(".already_added")
        return
      end

      @repository = current_user.repositories.build(github_id: github_id)
      fill_from_github(@repository)

      if @repository.save
        create_webhook(@repository)
        redirect_to repositories_path, notice: t(".success")
      else
        @github_repositories = available_github_repositories
        render :new, status: :unprocessable_entity
      end
    end

    private

    def available_github_repositories
      languages = Repository.language.values
      github_client.repos.select { |repo| languages.include?(repo[:language].to_s.downcase) }
    end

    def fill_from_github(repository)
      data = github_client.repository(repository.github_id)
      repository.assign_attributes(
        name: data[:name],
        full_name: data[:full_name],
        language: data[:language].to_s.downcase,
        clone_url: data[:clone_url],
        ssh_url: data[:ssh_url]
      )
    rescue Octokit::Error => e
      repository.errors.add(:github_id, e.message)
    end

    def create_webhook(repository)
      github_client.create_hook(
        repository.full_name,
        "web",
        { url: api_checks_url, content_type: "json" },
        { events: [ "push" ], active: true }
      )
    rescue Octokit::Error, ArgumentError => e
      Rails.logger.warn("Webhook for #{repository.full_name} was not created: #{e.message}")
    end
  end
end
