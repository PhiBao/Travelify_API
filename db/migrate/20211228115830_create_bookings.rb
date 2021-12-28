class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.integer :tour_id
      t.integer :user_id
      t.integer :adults
      t.integer :children, default: 0
      t.datetime :departure_date
      t.numeric :total, precision: 9, scale: 2
      t.integer :status

      t.timestamps
    end

    add_index :bookings, :user_id
    add_index :bookings, :tour_id
  end
end
