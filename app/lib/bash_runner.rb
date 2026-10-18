require "open3"

class BashRunner
  # → [stdout, exit_status]
  def self.start(command, chdir: Dir.pwd)
    stdout, _stderr, status = Open3.capture3(command, chdir: chdir)
    [ stdout, status.exitstatus ]
  end
end
