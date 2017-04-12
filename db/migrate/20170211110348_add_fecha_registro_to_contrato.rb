class AddFechaRegistroToContrato < ActiveRecord::Migration[5.0]
  def change
    add_column :contratos, :fecha_registro, :date
  end
end
