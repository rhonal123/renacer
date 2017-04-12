class AddFechaPagoToPago < ActiveRecord::Migration[5.0]
  def change
    add_column :pagos, :fecha_pago, :date
  end
end
