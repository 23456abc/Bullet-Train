class CreateBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :blocks do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.text :path

      t.timestamps
    end
  end
end
