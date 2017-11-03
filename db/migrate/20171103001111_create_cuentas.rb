class CreateCuentas < ActiveRecord::Migration[5.0]
  def change
    create_table :cuentas do |t|
      t.text :cuenta, limit: 12
      t.integer :banco

      t.timestamps
    end
    add_index :cuentas, :cuenta, unique: true 
  end
end
