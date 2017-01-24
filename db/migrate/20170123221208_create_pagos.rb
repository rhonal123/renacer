class CreatePagos < ActiveRecord::Migration[5.0]
  def change
    create_table :pagos do |t|
      t.belongs_to :contrato, foreign_key: true
      t.integer :semana
      t.float :monto, default: 0.0 
      t.string :estado, default: "pendiente" # pendiente -- pagado -- anulado
      t.timestamps
    end
  end
end
