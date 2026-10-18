require "shellwords"

class Git
  def self.clone(url, destination)
    stdout, status = BashRunner.start("git clone --depth 1 #{url.shellescape} #{destination.to_s.shellescape}")
    raise "git clone failed: #{stdout}" unless status.zero?
  end

  def self.last_commit(path)
    stdout, = BashRunner.start("git rev-parse HEAD", chdir: path)
    stdout.strip
  end
end
