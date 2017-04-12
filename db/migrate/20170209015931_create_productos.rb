class CreateProductos < ActiveRecord::Migration[5.0]
  def change
    create_table :productos do |t|
      t.string :descripcion, limit: 120
      t.float :precio , length:  15, decimals: 2
      t.timestamps
    end
  end
end
