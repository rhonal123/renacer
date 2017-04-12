class AddAnoToPago < ActiveRecord::Migration[5.0]
  def change
    add_column :pagos, :ano, :integer
  end
end
