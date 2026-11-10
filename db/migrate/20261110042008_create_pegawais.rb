class CreatePegawais < ActiveRecord::Migration[8.1]
  def change
    create_table :pegawais do |t|
      t.string :nama, null: false
      t.string :nip, null: false
      t.string :jabatan, null: false
      t.string :golongan, null: false
      t.references :perangkat_daerah, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pegawais, :nip, unique: true
  end
end
