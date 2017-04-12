class CreateClientesFiscales < ActiveRecord::Migration[5.0]
  def change
    create_table :clientes_fiscales do |t|
      t.string :identidad, limit: 16
      t.string :nombres, limit: 120
      t.text :direccion

      t.timestamps
    end
  end
end
