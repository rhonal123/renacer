class CreateFormaPagos < ActiveRecord::Migration[5.0]
  def change
    create_table :forma_pagos do |t|
      t.belongs_to :recibo, foreign_key: true
      t.float :monto
      t.date :fecha
      t.string :estado, limit: 10 # ACTIVO ANULADO
      t.string :tipo, limit: 16 # TRANSFERENCIA EFECTIVO DEPOSITO CHEQUE PUNTO 
      t.string :referencia, limit: 50
      t.timestamps
    end
  end
end
