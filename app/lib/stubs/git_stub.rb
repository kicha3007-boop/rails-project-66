module Stubs
  class GitStub
    def self.clone(_url, destination)
      FileUtils.mkdir_p(destination)
    end

    def self.last_commit(_path)
      "c0ffee0123456789abcdef0123456789abcdef01"
    end
  end
end
