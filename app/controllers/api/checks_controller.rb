module Api
  # Вебхук GitHub (событие push): запускает проверку репозитория
  class ChecksController < ActionController::API
    def create
      repositories = Repository.where(full_name: params.require(:repository).require(:full_name))
      return head :not_found if repositories.empty?

      repositories.each do |repository|
        check = repository.checks.create!
        RepositoryCheckJob.perform_later(check.id)
      end

      head :ok
    end
  end
end
