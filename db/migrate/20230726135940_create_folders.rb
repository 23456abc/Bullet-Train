class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.references :office, null: false, foreign_key: true
      t.integer :sort_order
      t.string :name
      t.text :path

      t.timestamps
    end
  end
end
