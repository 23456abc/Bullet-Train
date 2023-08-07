class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :team, null: false, foreign_key: true
      t.references :entryable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
