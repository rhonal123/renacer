class CreateContratos < ActiveRecord::Migration[5.0]
  def change
    create_table :contratos do |t|
      t.belongs_to :cliente, foreign_key: true
      t.belongs_to :plan, foreign_key: true
      t.date :desde
      t.date :hasta
      t.float :monto, default: 0  # variable 
      t.float :total, default: 0  # monto fijo 
      t.string :estado, default: "CREADO" # CREADO -> ACTIVO -> ANULADO -> VENCIDO
      t.timestamps
    end
  end
end
