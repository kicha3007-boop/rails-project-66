# Проверка репозитория: клонирование свежей версии и запуск линтера. Шаги отражаются в состоянии проверки
class RepositoryCheckRunner
  def initialize(check)
    @check = check
    @repository = check.repository
  end

  def run
    @check.start!

    Dir.mktmpdir("repository-check") do |dir|
      path = File.join(dir, "repo")
      git.clone(@repository.clone_url, path)

      linter = Linters.for(@repository.language)
      output, = bash_runner.start(linter.command(path))
      offenses = linter.parse(output, path)

      @check.update!(
        commit_id: git.last_commit(path),
        output: offenses.to_json,
        offenses_count: offenses.size,
        passed: offenses.empty?
      )
    end

    @check.finish!
  rescue StandardError => e
    Rails.logger.error("Repository check #{@check.id} failed: #{e.message}")
    @check.update!(passed: false)
    @check.fail! if @check.may_fail?
  ensure
    CheckMailer.with(check: @check).report.deliver_later unless @check.passed?
  end

  private

  def git
    ApplicationContainer[:git]
  end

  def bash_runner
    ApplicationContainer[:bash_runner]
  end
end
