class CreateTravellers < ActiveRecord::Migration[7.0]
  def change
    create_table :travellers do |t|
      t.integer :booking_id
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :note

      t.timestamps
    end
  end
end
