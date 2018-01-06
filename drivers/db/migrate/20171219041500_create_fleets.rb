class CreateFleets < ActiveRecord::Migration[5.1]
  def change
    create_table :fleets do |t|
      t.integer :service_id
      t.string :driver_name
      t.string :location, default: "Blok M"

      t.timestamps
    end
  end
end
