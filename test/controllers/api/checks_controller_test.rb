require "test_helper"

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    test "#create" do
      repository = repositories(:ruby)

      perform_enqueued_jobs do
        post api_checks_path, params: { repository: { full_name: repository.full_name } }, as: :json
      end

      assert_response :ok
      assert { repository.checks.order(:id).last.finished? }
    end

    test "#create for unknown repository" do
      post api_checks_path, params: { repository: { full_name: "unknown/repo" } }, as: :json

      assert_response :not_found
    end
  end
end
