class AddStripeColumnsToTables < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :tours, :stripe_price_id, :string
    add_column :tours, :stripe_product_id, :string
  end
end
