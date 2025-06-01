class AddDishNameToReviews < ActiveRecord::Migration[7.2]
  def change
    add_column :reviews, :dish_name, :string
  end
end
