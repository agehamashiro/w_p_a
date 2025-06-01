class AddDataToSuggestions < ActiveRecord::Migration[7.2]
  def change
    add_column :suggestions, :data, :text
  end
end
