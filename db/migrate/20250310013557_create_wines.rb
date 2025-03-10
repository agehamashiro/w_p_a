class CreateWines < ActiveRecord::Migration[7.2]
  def change
    create_table :wines do |t|
      t.integer :price
      t.string :region
      t.string :variety

      t.timestamps
    end
  end
end
