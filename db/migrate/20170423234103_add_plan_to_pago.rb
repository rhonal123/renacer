class AddPlanToPago < ActiveRecord::Migration[5.0]
  def change
    add_reference :pagos, :plan, foreign_key: true
  end
end
