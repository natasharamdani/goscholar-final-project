class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :origin
      t.string :destination
      t.string :payment_type
      t.decimal :distance, default: 1
      t.integer :price

      t.timestamps
    end
  end
end
