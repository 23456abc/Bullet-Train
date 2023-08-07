class CreateSites < ActiveRecord::Migration[7.0]
  def change
    create_table :sites do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.integer :sort_order

      t.timestamps
    end
  end
end
