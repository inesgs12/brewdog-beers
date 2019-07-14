class UpdateAbvToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :beers, :abv, :float
  end
end
