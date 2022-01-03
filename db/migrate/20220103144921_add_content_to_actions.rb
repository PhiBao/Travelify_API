class AddContentToActions < ActiveRecord::Migration[7.0]
  def change
    add_column :actions, :content, :string
  end
end
