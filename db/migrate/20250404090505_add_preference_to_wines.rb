class AddPreferenceToWines < ActiveRecord::Migration[7.2]
  def change
    add_column :wines, :preference, :string
  end
end
