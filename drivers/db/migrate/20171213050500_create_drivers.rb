class CreateDrivers < ActiveRecord::Migration[5.1]
  def change
    create_table :drivers do |t|
      t.string :fullname
      t.string :phone
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
