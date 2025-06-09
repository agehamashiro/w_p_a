class AddImageUrlToSuggestions < ActiveRecord::Migration[7.2]
  def change
    add_column :suggestions, :image_url, :string
  end
end
