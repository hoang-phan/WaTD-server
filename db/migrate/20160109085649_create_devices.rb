class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device_id
      t.string :reg_id

      t.timestamps null: false
    end

    add_index :devices, :device_id
    add_index :devices, :reg_id
  end
end
