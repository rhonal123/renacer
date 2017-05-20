class AddCobradorToPago < ActiveRecord::Migration[5.0]
  def change
    add_reference :pagos, :cobrador, foreign_key: true
    execute <<-SQL
      update pagos p set cobrador_id = (select cobrador_id from contratos where p.contrato_id = id ) where p.estado = 'pagado'
    SQL

  end
end
