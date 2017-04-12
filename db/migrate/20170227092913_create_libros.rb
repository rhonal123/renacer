class CreateLibros < ActiveRecord::Migration[5.0]
  def change
    create_table :libros do |t|
      t.integer :mes
      t.integer :ano
      t.float :base
      t.float :total
      t.boolean :declarado
      t.timestamps
    end
  end
end
