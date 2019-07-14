class Ingredient < ActiveRecord::Base
  has_many :beers, through: :beer_ingredient
  validates :name, uniqueness: true

end
