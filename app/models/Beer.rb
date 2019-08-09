class Beer < ActiveRecord::Base
  has_many :ingredients, through: :beer_ingredient
  has_many :foods, through: :beer_food
end
