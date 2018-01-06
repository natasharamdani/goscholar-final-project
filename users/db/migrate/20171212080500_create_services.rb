class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :service_type
      t.integer :price_per_km
    end
  end
end
