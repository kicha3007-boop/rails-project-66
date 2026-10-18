module Web
  module Repositories
    class ChecksController < Web::ApplicationController
      before_action :authenticate_user!

      def show
        @check = resource_repository.checks.find(params[:id])
      end

      def create
        check = resource_repository.checks.create!
        RepositoryCheckJob.perform_later(check.id)

        redirect_to repository_path(resource_repository), notice: t(".success")
      end

      private

      def resource_repository
        @resource_repository ||= current_user.repositories.find(params[:repository_id])
      end
    end
  end
end
