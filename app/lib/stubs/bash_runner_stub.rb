module Stubs
  class BashRunnerStub
    FIXTURES = Rails.root.join("test/fixtures/files")

    # Вместо запуска линтера отдаёт сохранённый отчёт без нарушений
    def self.start(command, chdir: nil)
      fixture = command.include?("eslint") ? "eslint.json" : "rubocop.json"
      [ File.read(FIXTURES.join(fixture)), 0 ]
    end
  end
end
