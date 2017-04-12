class CreateRecibos < ActiveRecord::Migration[5.0]
  def change
    create_table :recibos do |t|
      t.date :fecha
      t.string :concepto, limit: 300 
      t.belongs_to :cliente_fiscal, foreign_key: true
      t.string :estado # ACTIVO ANULADO
      t.float :monto
      t.belongs_to :factura, foreign_key: true
      t.timestamps
    end
  end
end
