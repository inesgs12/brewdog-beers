require 'highline'
require 'pry'
require_relative './quiz.rb'
require 'tty-prompt'
require 'pastel'
require 'tty-font'

$cli = HighLine.new
pastel = Pastel.new
prompt = TTY::Prompt.new
font = TTY::Font.new(:starwars)


def pastel 
  Pastel.new
end

def font
  TTY::Font.new(:doom)
end

def brewdog_title
  puts pastel.white(font.write("BREWDOG"))
  puts pastel.white(font.write("BEERS"))
  greeting
end

def greeting
r1 = $cli.ask pastel.blue.bold("Hi! What's your name?")
puts pastel.blue.bold("Hi #{r1}, welcome to BrewDog Beers!")
search
end

def all_beers
  Beer.all
end

def all_beer_names
  all_beers.map {|beer| beer.name}
end

def all_beer_names_output
  all_beer_names.each {|name| puts name}
end

def all_beer_names_output_menu
  all = all_beer_names.sort
  all.each {|name| puts name}.join(", ")
  sleep(2)
  search
end

def all_beer_ids
  beer_ids = {}
  all_beers.each {|beer| beer_ids[beer.name] = beer.id}
  return beer_ids
end 

def beer_info(name)
  t =  Beer.find_by(name: name).tagline
  d =  Beer.find_by(name: name).description
  a = Beer.find_by(name: name).abv
  f = foods_for_beer(name).join(", ")
  i = ingredients_for_beer(name).join(", ")
  puts pastel.cyan.bold("Tagline:") + pastel.black(" #{t}")
  puts pastel.cyan.bold("Description:") + pastel.black(" #{d}")
  puts pastel.cyan.bold("ABV:") + pastel.black(" #{a}") 
  puts pastel.cyan.bold("Food pairing:") + pastel.black(" #{f}")
  puts pastel.cyan.bold("Ingredients:") + pastel.black(" #{i}")
end

def search
puts pastel.cyan("You can search beers by:")
$cli.choose do |menu|
   menu.prompt = pastel.cyan("Search by:")
   menu.choice(pastel.black.bold(:Name)) {response = name_choice}
   menu.choice(pastel.black.bold(:Ingredients)) {response = ingredient_choice} 
   menu.choice(pastel.black.bold(:ABV)) {puts pastel.blue.bold("Okay! Select an option from the menu below to view by ABV:")
     abv_choice} 
   menu.choice(pastel.black.bold(:"Food Pairings")) {food_pairing_choice}
   menu.choice(pastel.black.bold(:"Surprise me!")) {puts pastel.black.bold(pastel.blue("Okay! Here's some info about a random beer"))
     surprise_me} 
  menu.choice(pastel.black.bold(:"Show All Beers")){response = all_beer_names_output_menu} #change all beer names output
  menu.choice(pastel.black.bold(:"Beer Quiz! 🤓 ")){quiz_greeting}
  menu.choice(pastel.black.bold(:"Quit")) {response = exit_menu}
  menu.default = :"Show All"
 end
end

def exit_menu
  puts pastel.blue.bold("Goodbye!!! Thanks for visiting!")
end

def name_choice 
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  answers = all_beer_names
  question = pastel.blue("Okay! Which BrewDog beer would you like to find out more about?")
  selection = prompt.select(question, answers.sort)
  beer_info(selection)
  follow_up = pastel.blue("Would you like to find out about another beer by name?")
  second_selection = prompt.yes? follow_up
    if second_selection == true 
      name_choice
    else
      puts pastel.black("I'll take you back to the main menu then.")
      sleep(1)
      search
    end
end

def all_ingredients
  Ingredient.all
end

def all_ingredients_names
  all_ingredients.map {|ingredient| ingredient.name}
end

def all_ingredient_types
  ingredient_types = {}
  all_ingredients.each {|ingredient| ingredient_types[ingredient.name] = ingredient.ingredient_type}
  return ingredient_types
end

def all_ingredients_types_output
  all_ingredient_types.each {|key, value| puts "#{value}: #{key}"}
end

def all_ingredient_ids
  ingredient_ids = {}
  all_ingredients.each {|ingredient| ingredient_ids[ingredient.name] = ingredient.id}
  return ingredient_ids
end

def all_beer_ingredients
  BeerIngredient.all
end

def ingredient_choice
  prompt = TTY::Prompt.new
  pastel = Pastel.new

  answers = all_ingredients_names
  question = pastel.blue("Okay! Which ingredient are you looking for?")
  selection = prompt.select(question, answers.sort)
  array = (beer_by_ingredient(selection)).join(", ")
  puts pastel.black("The beer(s) that contain(s) #{selection} is/are: #{array}.")
  follow_up = pastel.blue("Would you like to find out about more beers by ingredient?") 
  sleep(1)
  # binding.pry
  second_selection = prompt.yes? follow_up
    if second_selection == true
      sleep(1)
      ingredient_choice
    else
      puts pastel.black("I'll take you back to the main menu then.")
      sleep(1)
      search
    end
end


def beer_by_ingredient(response)
  ingredient_id_number = Ingredient.find_by(name: response).id
  BeerIngredient.where(ingredient_id: ingredient_id_number).map{|bi| bi.beer.name}
end
 

def all_beer_abvs
  beer_abvs = {}
  all_beers.each {|beer| beer_abvs[beer.name] = beer.abv}
  return beer_abvs
end


def abv_choice
   $cli.choose do |menu|
     menu.choice(:"Less than or equal to 5") {all_beer_abvs.each {|key, value|
        if value < 5 || value == 5
          puts pastel.black("Beer:") + pastel.cyan.bold("#{key};") + pastel.black(" ABV:") + pastel.cyan.bold(" #{value}")
        end}
      sleep(1)
      puts pastel.blue("Would you like to search more beers by ABV?")
      $cli.choose do |menu|
        menu.choice(:Y) {puts pastel.blue("Okay! Select an option from the menu:")
         abv_choice}
        menu.choice(:N) {
          $cli.say(pastel.black("I'll take you back to the main menu then."))
          search}
      end
       }
     menu.choice(:"More than 5 but less than 10") {all_beer_abvs.each {|key, value|
        if value > 5 && value < 10
          puts pastel.black("Beer:") + pastel.cyan.bold("#{key};") + pastel.black(" ABV:") + pastel.cyan.bold(" #{value}")
        end}
        sleep(1)
        puts pastel.blue("Would you like to search more beers by ABV?")
        $cli.choose do |menu|
          menu.choice(:Y) {puts pastel.blue("Okay! Select an option from the menu:")
           abv_choice}
          menu.choice(:N) {
            $cli.say(pastel.black("I'll take you back to the main menu then."))
            search}
        end
         }
     menu.choice(:"Greater than 10") {all_beer_abvs.each {|key, value|
      if value > 10
        puts pastel.black("Beer:") + pastel.cyan.bold("#{key};") + pastel.black(" ABV:") + pastel.cyan.bold(" #{value}")
      end}
      sleep(1)
      puts pastel.blue("Would you like to search more beers by ABV?")
      $cli.choose do |menu|
        menu.choice(:Y) {puts pastel.blue("Okay! Select an option from the menu:")
         abv_choice}
        menu.choice(:N) {
          $cli.say(pastel.black("I'll take you back to the main menu then."))
          search}
      end
       }
    menu.choice(:"Weakest beer") {puts "The weakest Brewdog beers are:"
    all_beer_abvs.each {|key, value|
      puts pastel.black("Beer:") + pastel.cyan.bold("#{key};") + pastel.black(" ABV:") + pastel.cyan.bold(" #{value}") if value == all_beer_abvs.values.min}
      sleep(1)
        puts pastel.blue("Would you like to search more beers by ABV?")
        $cli.choose do |menu|
          menu.choice(:Y) {puts pastel.blue("Okay! Select an option from the menu:")
           abv_choice}
          menu.choice(:N) {
            $cli.say(pastel.black("I'll take you back to the main menu then."))
            search}
        end
         }
    menu.choice(:"Strongest beer") {all_beer_abvs.each {|key, value|
          puts pastel.green.bold("The strongest Brewdog beer is #{key} with an ABV of #{value} - WOW!") if value == all_beer_abvs.values.max}
          sleep(1)
          puts pastel.blue("Would you like to search more beers by ABV?")
          $cli.choose do |menu|
            menu.choice(:Y) {puts pastel.blue("Okay! Select an option from the menu:")
             abv_choice}
            menu.choice(:N) {
              $cli.say(pastel.black("I'll take you back to the main menu then."))
              search}
          end
           }
end
end

def all_foods
  Food.all
end

def all_food_names
  all_foods.map {|food| food.name}
end

def all_food_names_output
  all_food_names.each {|name| puts name}
end

def all_food_ids
  food_ids = {}
  all_foods.each {|food| food_ids[food.name] = food.id}
  return food_ids
end

def all_food_pairings
  BeerFood.all
end

def food_pairing_choice
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  answers = ["Food", "Beer"]
  question =pastel.blue("How would you like to search food pairings?")
  selection = prompt.select(question, answers)
    if selection == "Food"
      food_selection = prompt.select(pastel.blue("Okay! Select the food you'd like to search by."), all_food_names.sort)
      food_pairing_by_food(food_selection)
    elsif selection == "Beer"
      beer_selection = prompt.select(pastel.blue("Okay! Select the beer you'd like to search by."), all_beer_names.sort)
      food_pairing_by_beer(beer_selection)
    end
end

def food_pairing_by_beer(response)
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  if all_beer_names.include?(response)
    bid = all_beer_ids[response]
    relevant_pairings = all_food_pairings.select{|record| record.beer_id == bid}
    fids = relevant_pairings.map{|pairing| pairing.food_id}
    food_names = []
    fids.each{|foodid|food_names << all_food_ids.key(foodid)}
  puts pastel.black("The foods that go well with #{response} are:")
  food_names.each {|foodname| puts pastel.cyan(foodname)}
  sleep(1)
  puts pastel.blue("Would you like to find out about another beer-food pairing?")
    $cli.choose do |menu|
     menu.choice(:Y) {food_pairing_choice}
      menu.choice(:N) {$cli.say("I'll take you back to the main menu then.")
        sleep(1)
        search}
   end
 end
end

def food_pairing_by_food(response)
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  if all_food_names.include?(response)
    fid = all_food_ids[response]
    relevant_pairing = all_food_pairings.select{|record| record.food_id == fid}
    bids = relevant_pairing.map{|pairing| pairing.beer_id}
    beer_names = []
    bids.each{|beerid|beer_names << all_beer_ids.key(beerid)}
  puts pastel.black("The beer that goes well with #{response} is:")
  beer_names.each {|beername| puts pastel.cyan(beername)}
  sleep(1)
  puts pastel.blue("Would you like to find out about another beer-food pairing?")
    $cli.choose do |menu|
     menu.choice(:Y) {food_pairing_choice}
      menu.choice(:N) {$cli.say("I'll take you back to the main menu then.")
        sleep(1)
        search}
   end
 end
end

def random_beer
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  all_beer_names.sample
end

def surprise_me
  prompt = TTY::Prompt.new
  pastel = Pastel.new
  name = random_beer
  puts pastel.cyan.bold("Name:") + pastel.green.bold("#{name}")
  beer_info(name)
  sleep(1)
  puts pastel.green("Would you like to discover more beers?")
  $cli.choose do |menu|
   menu.choice(:Y) {puts pastel.blue("Okay! Here's another random beer")
     surprise_me}
    menu.choice(:N) {
      $cli.say("I'll take you back to the main menu then.")
      search}
  end
end


def foods_for_beer(beer)
  beer_id_number = Beer.find_by(name: beer).id
  BeerFood.where(beer_id: beer_id_number).map{ |bf| bf.food.name}

end

def ingredients_for_beer(beer)
  beer_id_number = Beer.find_by(name: beer).id
  BeerIngredient.where(beer_id: beer_id_number).map{ |bi| bi.ingredient.name}
end


