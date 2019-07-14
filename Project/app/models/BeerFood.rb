class BeerFood < ActiveRecord::Base
  belongs_to :food
  belongs_to :beer
end
