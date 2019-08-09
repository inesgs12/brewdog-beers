class BeerIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :beer
end
