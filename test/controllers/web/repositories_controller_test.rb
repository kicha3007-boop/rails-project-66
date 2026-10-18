require "test_helper"

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:two)
    end

    test "#index" do
      sign_in users(:one)
      get repositories_path

      assert_response :success
      assert { response.body.include?(repositories(:ruby).name) }
    end

    test "#new" do
      sign_in @user
      get new_repository_path

      assert_response :success
      assert { response.body.include?("hexlet/hexlet-cv") }
    end

    test "#create" do
      sign_in @user
      post repositories_path, params: { repository: { github_id: 1_296_269 } }

      repository = @user.repositories.find_by(github_id: 1_296_269)

      assert_redirected_to repositories_path
      assert { repository }
      assert { repository.full_name == "hexlet/hexlet-cv" }
      assert { repository.language.ruby? }
    end

    test "#create twice keeps one repository" do
      sign_in users(:one)
      post repositories_path, params: { repository: { github_id: repositories(:ruby).github_id } }

      assert_redirected_to repositories_path
      assert { users(:one).repositories.where(github_id: repositories(:ruby).github_id).count == 1 }
    end

    test "#show" do
      sign_in users(:one)
      get repository_path(repositories(:ruby))

      assert_response :success
      assert { response.body.include?(repositories(:ruby).full_name) }
    end

    test "#new redirects guest" do
      get new_repository_path

      assert_redirected_to root_path
    end

    test "#show is not available for other user" do
      sign_in @user
      get repository_path(repositories(:ruby))

      assert_response :not_found
    end
  end
end
