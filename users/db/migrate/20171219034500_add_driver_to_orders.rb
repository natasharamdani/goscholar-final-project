class AddDriverToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :driver_id, :integer
    add_column :orders, :driver_name, :string
  end
end
