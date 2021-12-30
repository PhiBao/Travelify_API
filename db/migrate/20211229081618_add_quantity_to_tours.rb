class AddQuantityToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :quantity, :decimal, precision: 2, scale: 1, default: 0.0
  end
end
