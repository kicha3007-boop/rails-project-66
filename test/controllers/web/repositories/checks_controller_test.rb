require "test_helper"

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        sign_in users(:one)
        @repository = repositories(:ruby)
      end

      test "#create" do
        perform_enqueued_jobs do
          post repository_checks_path(@repository)
        end

        check = @repository.checks.order(:id).last

        assert_redirected_to repository_path(@repository)
        assert { check.finished? }
        assert { check.passed? }
        assert { check.commit_id.present? }
      end

      test "#create for javascript repository" do
        repository = repositories(:javascript)

        perform_enqueued_jobs do
          post repository_checks_path(repository)
        end

        assert { repository.checks.last.finished? }
      end

      test "#show" do
        check = repository_checks(:finished)
        get repository_check_path(@repository, check)

        assert_response :success
        assert { response.body.include?("Завершена") }
      end
    end
  end
end
