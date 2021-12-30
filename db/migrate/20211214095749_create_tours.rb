class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.integer :kind
      t.string :name
      t.text :description
      t.string :time # Only available in single tour
      t.integer :limit # Only available in fixed tour
      t.datetime :begin_date # Only available in fixed tour
      t.datetime :return_date # Only available in fixed tour
      t.integer :price
      t.string :departure

      t.timestamps
    end
  end
end
