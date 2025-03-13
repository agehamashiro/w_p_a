class CreateRecipeSites < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_sites do |t|
      t.string :name
      t.string :url
      t.string :image_url

      t.timestamps
    end
  end
end
