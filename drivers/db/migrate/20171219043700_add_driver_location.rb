class AddDriverLocation < ActiveRecord::Migration[5.1]
  def change
    add_reference :fleets, :driver, foreign: true
    add_column :drivers, :location, :string
  end
end
