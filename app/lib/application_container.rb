# Внешние зависимости приложения. В тестах они подменяются заглушками без сети и внешних программ
class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { Stubs::OctokitClientStub }
    register :git, -> { Stubs::GitStub }
    register :bash_runner, -> { Stubs::BashRunnerStub }
  else
    register :octokit_client, -> { Octokit::Client }
    register :git, -> { Git }
    register :bash_runner, -> { BashRunner }
  end
end
