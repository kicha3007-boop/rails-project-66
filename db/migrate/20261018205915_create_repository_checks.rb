class CreateRepositoryChecks < ActiveRecord::Migration[8.1]
  def change
    create_table :repository_checks do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :aasm_state, null: false, default: "created"
      t.string :commit_id
      t.boolean :passed, null: false, default: false
      t.text :output
      t.integer :offenses_count, null: false, default: 0

      t.timestamps
    end
  end
end
