class AddPlanToPago < ActiveRecord::Migration[5.0]
  def change
    add_reference :pagos, :plan, foreign_key: true
    execute <<-SQL
      update pagos p set plan_id = (select plan_id from contratos where p.contrato_id = id ) 
    SQL
  end
end
