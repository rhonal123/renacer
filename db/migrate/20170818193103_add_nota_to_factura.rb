class AddNotaToFactura < ActiveRecord::Migration[5.0]
  def change
    add_column :facturas, :nota, :text
  end
end
