class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :beers do |t|
      t.string :name
      t.string :tagline
      t.string :description
      t.integer :abv
    end
    create_table :ingredients do |t|
      t.string :name
    end
    create_table :beeringredients do |t|
      t.integer :beer_id
      t.integer :food_id
    end
    create_table :foods do |t|
      t.string :name
    end
    create_table :beerfoods do |t|
      t.integer :beer_id
      t.integer :food_id
    end
  end
end
