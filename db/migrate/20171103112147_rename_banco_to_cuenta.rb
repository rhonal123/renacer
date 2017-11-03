class RenameBancoToCuenta < ActiveRecord::Migration[5.0]
  def change
  	rename_column :cuentas, :banco, :banco_id
  	add_foreign_key :cuentas, :bancos
  end
end
