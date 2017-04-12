class AddCobradorToContrato < ActiveRecord::Migration[5.0]
  def change
    add_column :contratos, :cobrador, :string
  end
end
