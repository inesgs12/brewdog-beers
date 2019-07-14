class BeerIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :beer
  # validates :beer_id && :ingredient_id, uniqueness: true
end
