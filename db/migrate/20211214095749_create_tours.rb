class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.integer :kind
      t.string :name
      t.text :description
      t.string :time # Only available in single tour
      t.integer :limit # Only available in fixed tour
      t.datetime :departure_day # Only available in fixed tour
      t.datetime :terminal_day # Only available in fixed tour
      t.numeric :price, precision: 9, scale: 2

      t.timestamps
    end
  end
end
