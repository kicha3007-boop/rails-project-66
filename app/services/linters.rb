# Линтеры по языку репозитория. Конфиги берутся из приложения (config/linters), а не из проверяемого репозитория
module Linters
  def self.for(language)
    case language.to_s
    when "ruby" then Rubocop
    when "javascript" then Eslint
    else raise ArgumentError, "Unsupported language: #{language}"
    end
  end

  module Rubocop
    CONFIG = Rails.root.join("config/linters/rubocop.yml")

    def self.command(path)
      "bundle exec rubocop --config #{CONFIG} --format json #{path}"
    end

    def self.parse(output, path)
      JSON.parse(output).fetch("files", []).flat_map do |file|
        file.fetch("offenses", []).map do |offense|
          {
            path: file["path"].to_s.delete_prefix("#{path}/"),
            line: offense.dig("location", "line"),
            rule: offense["cop_name"],
            message: offense["message"]
          }
        end
      end
    end
  end

  module Eslint
    CONFIG = Rails.root.join("config/linters/eslint.config.mjs")
    BIN = Rails.root.join("node_modules/.bin/eslint")

    # С --config ESLint 9 считает базовым каталогом текущий, поэтому запуск идёт из корня клона
    def self.command(path)
      "cd #{path} && #{BIN} --no-config-lookup --config #{CONFIG} --format json ."
    end

    def self.parse(output, path)
      JSON.parse(output).flat_map do |file|
        file.fetch("messages", []).map do |message|
          {
            path: file["filePath"].to_s.delete_prefix("#{path}/"),
            line: message["line"],
            rule: message["ruleId"],
            message: message["message"]
          }
        end
      end
    end
  end
end
