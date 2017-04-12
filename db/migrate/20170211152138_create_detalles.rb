class CreateDetalles < ActiveRecord::Migration[5.0]
  def change
    create_table :detalles do |t|
      t.belongs_to :factura, foreign_key: true
      t.belongs_to :producto, foreign_key: true
      t.float :cantidad
      t.float :precio_unitario
      t.float :precio

      t.timestamps
    end
  end
end
