require_relative '../config/environment.rb'

brewdog_title

# to search by part of a string elsif all_ingredient_types.any?{|i| i.include? response}

# cli.ask("Enter your password:  ") { |q| q.echo = false }
# cli.ask("Enter your password:  ") { |q| q.echo = "x" }
# cli.say("This should be <%= color('bold', BOLD) %>!")

# HighLine::Menu.index_color   = :rgb_77bbff # set default index color
#
# cli.choose do |menu|
#   menu.index_color  = :rgb_999999      # override default color of index
#                                        # you can also use constants like :blue
#   menu.prompt = "Please choose your favorite programming language?  "
#   menu.choice(:ruby) { cli.say("Good choice!") }
#   menu.choices(:python, :perl) { cli.say("Not from around here, are you?") }
# end
