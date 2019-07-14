class ChangeBeeringredientColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :beeringredients, :food_id, :ingredient_id
  end
end
