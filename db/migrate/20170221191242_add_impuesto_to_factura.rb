class AddImpuestoToFactura < ActiveRecord::Migration[5.0]
  def change
    add_reference :facturas, :impuesto, foreign_key: true
  end
end
