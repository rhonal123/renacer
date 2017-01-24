class CreatePlanes < ActiveRecord::Migration[5.0]
  def change
    create_table :planes do |t|
      t.string :nombre, limit: 120
      t.float :monto, default: 0
      t.text :componentes
      t.timestamps
    end
  end
end
