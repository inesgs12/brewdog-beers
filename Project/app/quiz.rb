require 'pry'
require 'highline'
require 'tty-prompt'
require 'pastel'
require_relative './start_menu.rb'

$cli = HighLine.new
prompt = TTY::Prompt.new
pastel = Pastel.new



def quiz_greeting 
pastel = Pastel.new
score = 0
 puts pastel.blue.bold("Let's test you beer knowledge! 🍻 ")
 sleep(1)
 beer_abv_question(score)
end


def beer_abv_question(score)
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    # remove line 13 when running the main program via run.rb
    beer_id_random = rand(1..25)
    beer_selected = Beer.all.find_by(id: beer_id_random)
    sample1 = Beer.all.select{|beer| beer.id != beer_selected.id}.sample
    sample2 = Beer.all.select{|beer| beer.id != beer_selected.id && beer.id != sample1.id }.sample
    sample3 = Beer.all.select{|beer| beer.id != beer_selected.id && beer.id != sample1.id && beer.id != sample2.id}.sample
    answers = [beer_selected.name, sample1.name, sample2.name, sample3.name]
    all_answers = [answers.shuffle, "Exit"].flatten
    question = pastel.blue.bold("Which beer has a #{beer_selected.abv} ABV? 🍻 ")
    selection = prompt.select(question, all_answers)
    if selection == beer_selected.name
        puts pastel.green.bold("Geniouuuss! 🤩 ")
        sleep(1)
        puts pastel.white(beer_info(beer_selected.name))
        score += 1
        sleep(1)
        food_pairing_question(score)
    elsif selection == sample1.name || selection == sample2.name || selection == sample3.name
        puts pastel.red.bold("Nope, at least you tried! The correct answer is #{beer_selected.name}.")
        sleep(1)
        puts pastel.white(beer_info(beer_selected.name))
        sleep(1)
        food_pairing_question(score)
    elsif selection == "Exit"
        search
    end

end


def food_pairing_question(score)
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    # remove line 13 when running the main program via run.rb
   food_random = rand(1..77)
   food_pairing = Food.all.find_by(id: food_random)
   beer_that_pairs_object = BeerFood.where(food_id: food_random).map{|bf| bf.beer}
   beer_that_pairs_name = beer_that_pairs_object.first.name
   question = pastel.blue.bold("Which beer goes well with #{food_pairing.name}? 🥘 ")
   sample1 = Beer.all.select{|beer| beer.id != beer_that_pairs_object.first.id}.sample
   sample2 = Beer.all.select{|beer| beer.id != beer_that_pairs_object.first.id && beer.id != sample1.id }.sample
   sample3 = Beer.all.select{|beer| beer.id != beer_that_pairs_object.first.id && beer.id != sample1.id && beer.id != sample2.id}.sample
   answers = [beer_that_pairs_name, sample1.name, sample2.name, sample3.name]
   all_answers = [answers.shuffle, "Exit"].flatten
    selection = prompt.select(question, all_answers) 
    if selection == beer_that_pairs_object.first.name
      puts pastel.green.bold("Yes, you are right!! ✨ ")
      sleep(1)
      puts pastel.white(beer_info(beer_that_pairs_name))
      score += 1
      sleep(1)
      tagline_question(score)
    elsif selection == sample1.name || selection == sample2.name || selection == sample3.name
        puts pastel.red.bold("Nope, at least you tried! The correct answer is #{beer_that_pairs_name}.")
        sleep(1)
        puts pastel.white(beer_info(beer_that_pairs_name))
        sleep(1)
        tagline_question(score)
    elsif selection == "Exit"
        search
    end
end

def tagline_question(score)
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    beer_id_random = rand(1..25)
    beer_selected = Beer.all.find_by(id: beer_id_random)
    sample1 = Beer.all.select{|beer| beer.id != beer_selected.id}.sample
    sample2 = Beer.all.select{|beer| beer.id != beer_selected.id && beer.id != sample1.id }.sample
    sample3 = Beer.all.select{|beer| beer.id != beer_selected.id && beer.id != sample1.id && beer.id != sample2.id}.sample
    answers = [beer_selected.name, sample1.name, sample2.name, sample3.name]
    all_answers = [answers.shuffle, "Exit"]
    question = pastel.blue.bold("Which beers is described as a #{beer_selected.tagline}? 🍻 ")
    selection = prompt.select(question, all_answers)

    if selection == beer_selected.name
        puts pastel.green.bold("Yassss! 💃 ")
        sleep(1)
        puts pastel.white(beer_info(beer_selected.name))
        score += 1
        sleep(1)
        ingredients_question(score)
    elsif selection == sample1.name || selection == sample2.name || selection == sample3.name
        puts pastel.red.bold("Nope, at least you tried! The correct answer is #{beer_selected.name}.")
        sleep(1)
        puts pastel.white(beer_info(beer_selected.name))
        sleep(1)
        ingredients_question(score)
    elsif selection == "Exit"
        search
    end
end

def ingredients_question(score)
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    # remove line 13 when running the main program via run.rb
    ingredient_random = rand(1..69)
    ingredient_in_beer = Ingredient.all.find_by(id: ingredient_random)
    bi_id = BeerIngredient.select {|beeringredient| beeringredient.ingredient_id == ingredient_in_beer.id}
    bi_id_final = bi_id.first
    b_id = bi_id_final.beer_id
    beer_with_ingredient = Beer.select{|beer| beer.id == b_id}
    sample1 = Beer.all.select{|beer| beer.id != beer_with_ingredient.first.id}.sample
    sample2 = Beer.all.select{|beer| beer.id != beer_with_ingredient.first.id && beer.id != sample1.id }.sample
    sample3 = Beer.all.select{|beer| beer.id != beer_with_ingredient.first.id && beer.id != sample1.id && beer.id != sample2.id}.sample
    answers = [beer_with_ingredient.first.name, sample1.name, sample2.name, sample3.name]
    all_answers = [answers.shuffle, "Exit"]
    question = pastel.blue.bold("Which of these beers is made with #{ingredient_in_beer.name} (#{ingredient_in_beer.ingredient_type}) 🍺 ?")
    selection = prompt.select(question, all_answers)
    if selection == beer_with_ingredient.first.name
       puts pastel.green.bold("Yes, good job!! 🌟 ")
       sleep(1)
       puts pastel.white(beer_info(beer_with_ingredient.first.name))
       score +=1
       sleep(1)
       beer_and_food_pairing(score)
    elsif selection == sample1.name || selection == sample2.name || selection == sample3.name
        puts pastel.red.bold("Nope, at least you tried! The correct answer is #{beer_with_ingredient.first.name}.")
        sleep(1)
        puts pastel.white(beer_info(beer_with_ingredient.first.name))
        sleep(1)
        beer_and_food_pairing(score)
    elsif selection == "Exit"
        search
    end


end

def beer_and_food_pairing(score)
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    beer_id_random = rand(1..25)
    beer_selected = Beer.all.find_by(id:  beer_id_random)
    food_random = rand(1..77)
    food_pairing = Food.all.find_by(id: food_random)
    bf = BeerFood.all.select {|beerfood| beerfood.beer_id == beer_selected.id && beerfood.food_id == food_pairing.id}
    question = pastel.blue.bold("Does #{beer_selected.name} pair well with #{food_pairing.name}? 🤤 ")
    selection = prompt.yes? question

    if selection == false && bf.length == 0 
       puts pastel.green.bold("You're right! Eww! 🤢 ")
       score += 1
    elsif selection == false && bf.length > 0 
       puts pastel.red.bold("Actually, they do, try it!")
    elsif selection == true && bf.length > 0
       puts pastel.green.bold("Yes! You've got great taste!🤤 ")
       score += 1
    elsif selection == true && bf.length == 0 
       puts pastel.red.bold("Maybe, but we don't recommend it... sorry.")
    end
    sleep(1)
    final_score(score)  
end


def final_score(score)
    if score > 2
        puts pastel.white(font.write("WINNER"))
        puts pastel.blue.bold.bold("You passed! Congrats! You got #{score}/5 right!")
    elsif score == 0 
        puts pastel.red.bold("You didn't get any questions right. You can do better, keep practicing!")
    elsif score == 1 || score == 2
        puts pastel.red.bold("You only got #{score}/5 right. You can do better, keep practicing!")
    end
    sleep(1)
    play_again?
end

def play_again?
    prompt = TTY::Prompt.new
    pastel = Pastel.new
    # remove line 13 when running the main program via run.rb
    selection = prompt.yes? "Do you want to play again?"

    if selection == true 
        sleep(1)
        quiz_greeting
    else
        search
    end

end

# binding.pry
"End"


