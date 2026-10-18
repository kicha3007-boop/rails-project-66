class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :checking
    state :finished
    state :failed

    event :start do
      transitions from: :created, to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: %i[created checking], to: :failed
    end
  end

  # Нарушения линтера, разобранные из сохранённого JSON-отчёта: [{ path:, line:, rule:, message: }]
  def offenses
    return [] if output.blank?

    JSON.parse(output, symbolize_names: true)
  rescue JSON::ParserError
    []
  end
end
