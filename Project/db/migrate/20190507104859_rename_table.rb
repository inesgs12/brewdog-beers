class RenameTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :beeringredients, :beer_ingredients
    rename_table :beerfoods, :beer_foods
  end
end
