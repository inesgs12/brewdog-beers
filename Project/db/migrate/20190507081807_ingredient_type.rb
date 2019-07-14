class IngredientType < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :ingredient_type, :string
  end
end
