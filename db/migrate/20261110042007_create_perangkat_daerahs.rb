class CreatePerangkatDaerahs < ActiveRecord::Migration[8.1]
  def change
    create_table :perangkat_daerahs do |t|
      t.string :nama, null: false

      t.timestamps
    end
    add_index :perangkat_daerahs, :nama, unique: true
  end
end
