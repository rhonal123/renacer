class CreateFacturas < ActiveRecord::Migration[5.0]
  def change
    create_table :facturas do |t|
      t.date :fecha
      t.string :tipo, default: "contado" #contado credito
      t.string :estado #PENDIENTE CANCELADA ANULADA 
      t.float :base #monto sin impuestos 
      t.float :total #monto con impuesto 
      t.float :saldo #monto actual de la factura 
      t.text :observacion
      t.belongs_to :cliente_fiscal, foreign_key: true
      t.text :direccion
      t.timestamps
    end
  end
end
