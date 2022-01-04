class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string :commentable_type
      t.integer :commentable_id
      t.text :body
      t.boolean :state, default: true
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
