class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.integer :user_id
      t.integer :scope
      t.string :target_type
      t.integer :target_id
      t.string :data

      t.timestamps
    end

    add_index :actions, :user_id
    add_index :actions, [:target_type, :target_id]
  end
end
