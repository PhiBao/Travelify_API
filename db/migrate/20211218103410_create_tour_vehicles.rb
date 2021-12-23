class CreateTourVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_vehicles do |t|
      t.integer :vehicle_id
      t.integer :tour_id
    end

    add_index :tour_vehicles, [:tour_id, :vehicle_id], unique: true
  end
end
