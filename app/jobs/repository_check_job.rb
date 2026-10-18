class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    RepositoryCheckRunner.new(Repository::Check.find(check_id)).run
  end
end
