class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :tour_id
      t.integer :hearts
      t.text :body
      t.boolean :state, default: true

      t.timestamps
    end

    add_index :reviews, :user_id
    add_index :reviews, :tour_id
  end
end
