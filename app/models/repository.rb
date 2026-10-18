class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: "Repository::Check", dependent: :destroy

  enumerize :language, in: %w[ruby javascript]

  validates :github_id, presence: true, uniqueness: { scope: :user_id }

  def last_check
    checks.order(id: :desc).first
  end
end
