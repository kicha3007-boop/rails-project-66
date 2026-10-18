require "test_helper"

class LintersTest < ActiveSupport::TestCase
  test "rubocop report is parsed into offenses" do
    output = {
      files: [
        {
          path: "/tmp/repo/app/models/user.rb",
          offenses: [ { cop_name: "Style/StringLiterals", message: "Prefer double quotes", location: { line: 3 } } ]
        }
      ]
    }.to_json

    offenses = Linters::Rubocop.parse(output, "/tmp/repo")

    assert { offenses == [ { path: "app/models/user.rb", line: 3, rule: "Style/StringLiterals", message: "Prefer double quotes" } ] }
  end

  test "eslint report is parsed into offenses" do
    output = [
      { filePath: "/tmp/repo/index.js", messages: [ { ruleId: "no-unused-vars", message: "'a' is unused", line: 1 } ] }
    ].to_json

    offenses = Linters::Eslint.parse(output, "/tmp/repo")

    assert { offenses == [ { path: "index.js", line: 1, rule: "no-unused-vars", message: "'a' is unused" } ] }
  end

  test "linter is chosen by language" do
    assert { Linters.for("ruby") == Linters::Rubocop }
    assert { Linters.for("javascript") == Linters::Eslint }
  end
end
