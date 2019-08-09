class Food < ActiveRecord::Base
  has_many :beers, through: :beer_food
end
