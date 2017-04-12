class AddTelefonoToFactura < ActiveRecord::Migration[5.0]
  def change
    add_column :facturas, :telefono, :string, limit: 35
  end
end
