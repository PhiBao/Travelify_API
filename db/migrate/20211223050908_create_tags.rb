class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :tour_tags_count, default: 0
    end

    add_index :tags, :name
  end
end
