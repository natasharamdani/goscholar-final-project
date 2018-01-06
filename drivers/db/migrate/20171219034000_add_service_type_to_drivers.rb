class AddServiceTypeToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :service_type, :string
  end
end
