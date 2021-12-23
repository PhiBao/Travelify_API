class CreateTourTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tour_tags do |t|
      t.integer :tag_id
      t.integer :tour_id
    end
  
    add_index :tour_tags, [:tour_id, :tag_id], unique: true
  end
end
