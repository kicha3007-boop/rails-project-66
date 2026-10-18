module Stubs
  class OctokitClientStub
    REPOS = [
      {
        id: 1_296_269,
        name: "hexlet-cv",
        full_name: "hexlet/hexlet-cv",
        language: "Ruby",
        clone_url: "https://github.com/hexlet/hexlet-cv.git",
        ssh_url: "git@github.com:hexlet/hexlet-cv.git"
      },
      {
        id: 1_296_270,
        name: "hexlet-js",
        full_name: "hexlet/hexlet-js",
        language: "JavaScript",
        clone_url: "https://github.com/hexlet/hexlet-js.git",
        ssh_url: "git@github.com:hexlet/hexlet-js.git"
      }
    ].freeze

    def initialize(**_options); end

    def repos
      REPOS.map { |repo| Sawyer::Resource.new(Sawyer::Agent.new(""), repo) }
    end

    def repository(id)
      repos.find { |repo| repo.id == id.to_i } || raise(Octokit::NotFound)
    end

    def create_hook(*_args)
      true
    end
  end
end
