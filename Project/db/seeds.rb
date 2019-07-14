require 'pry'
require 'rest-client'

def update_tables
  res = RestClient.get("https://api.punkapi.com/v2/beers") #is an array

  all_data = JSON.parse(res)

  all_data.each do |beer|
    target_beer = Beer.find_or_create_by(
      name:beer["name"],
      tagline:beer["tagline"],
      description:beer["description"],
      abv:beer["abv"]
    )

    beer["ingredients"].each do |type, ingredient_values|
      if type == "yeast"
        ing = Ingredient.find_or_create_by(name:ingredient_values,ingredient_type:type)
        bi = BeerIngredient.find_or_create_by(beer_id:target_beer.id, ingredient_id:ing.id)
      else
        ingredient_values.each do |ingredient_hash|
          ing = Ingredient.find_or_create_by(name:ingredient_hash["name"],ingredient_type:type)
          bi = BeerIngredient.find_or_create_by(beer_id:target_beer.id, ingredient_id:ing.id)
        end
      end
    end

    beer["food_pairing"].each {|food|
      f = Food.find_or_create_by(name: food)
      bf = BeerFood.find_or_create_by(beer_id: Beer.find_by(name: beer["name"]).id, food_id: Food.find_by(name: food).id)
    }
  end
end
update_tables

# beer_table_data = all_data.each {|beer|
#   b = Beer.new(name: beer["name"], tagline: beer["tagline"], description: beer["description"], abv: beer["abv"])
#   b.save
# }

# food_table_data = all_data.each {|beer|
#   beer["food_pairing"].each {|food|
#     f = Food.new(name: food)
#     f.save
#   }
# }

# ingredient_table_data = all_data.each do |beer|
#   beer["ingredients"].each do |key, value|
#     if value.kind_of?(Array)
#       value.each {|ingredient|
#         i = Ingredient.new(name: ingredient["name"], ingredient_type: key)
#         i.save}
#     else
#         i = Ingredient.new(name: value, ingredient_type: key)
#         i.save
#     end
#   end
# end

# beeringredient_table_data = all_data.each {|beer|
#   beer["ingredients"].each do |key, value|
#     if value.kind_of?(Array)
#       value.each {|ingredient|
#       bi = BeerIngredient.new(beer_id: Beer.find_by(name: beer["name"]).id, ingredient_id: Ingredient.find_by(name: ingredient["name"]).id)
#       bi.save}
#     else
#       bi = BeerIngredient.new(beer_id: Beer.find_by(name: beer["name"]).id, ingredient_id: Ingredient.find_by(name: value).id)
#       bi.save
#     end
#   end
# }

# beerfood_table_data = all_data.each {|beer|
#   beer["food_pairing"].each {|food|
#     bf = BeerFood.new(beer_id: Beer.find_by(name: beer["name"]).id, food_id: Food.find_by(name: food).id)
#     bf.save
#   }
# }
# binding.pry

# "Hi"
