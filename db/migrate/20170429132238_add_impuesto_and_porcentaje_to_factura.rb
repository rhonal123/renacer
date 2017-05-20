class AddImpuestoAndPorcentajeToFactura < ActiveRecord::Migration[5.0]
  def change
    add_column :facturas, :monto_impuesto, :float
    add_column :facturas, :porcentaje, :float
  end
end
