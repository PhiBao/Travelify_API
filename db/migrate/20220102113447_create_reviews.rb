class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :booking_id
      t.integer :hearts
      t.text :body
      t.boolean :state, default: true

      t.timestamps
    end

    add_index :reviews, :booking_id
  end
end
