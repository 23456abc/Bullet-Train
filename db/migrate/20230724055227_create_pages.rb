class CreatePages < ActiveRecord::Migration[7.0]
  def change
    create_table :pages do |t|
      t.references :sites, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.text :path

      t.timestamps
    end
  end
end
