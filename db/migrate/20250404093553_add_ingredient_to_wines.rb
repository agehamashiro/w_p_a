class AddIngredientToWines < ActiveRecord::Migration[7.2]
  def change
    add_column :wines, :ingredient, :string
  end
end
