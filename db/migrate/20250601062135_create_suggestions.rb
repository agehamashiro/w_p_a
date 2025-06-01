class CreateSuggestions < ActiveRecord::Migration[7.2]
  def change
    create_table :suggestions do |t|
      t.references :wine, null: false, foreign_key: true
      t.string :dish_name
      t.text :ingredients

      t.timestamps
    end
  end
end
