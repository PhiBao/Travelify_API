class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.string :action
      t.string :notifiable_type
      t.integer :notifiable_id
      t.boolean :status, default: false

      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :recipient_id
    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
