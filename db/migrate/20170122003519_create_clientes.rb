class CreateClientes < ActiveRecord::Migration[5.0]
  def change
    create_table :clientes do |t|
      t.string :identidad, limit: 16
      t.string :apellidos, limit: 120
      t.string :nombres, limit: 120
      t.date :fecha
      t.string :direccion, limit: 400
      t.string :telefono, limit: 80

      t.timestamps
    end
  end
end
