class AddTelefonoToClienteFiscal < ActiveRecord::Migration[5.0]
  def change
    add_column :clientes_fiscales, :telefono, :string, limit: 35
  end
end
