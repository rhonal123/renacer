class AddCobradorIdToContrato < ActiveRecord::Migration[5.0]
  def change
  	rename_column :contratos, :cobrador, :cobrador_old
    add_reference :contratos, :cobrador, foreign_key: true
  end
end
