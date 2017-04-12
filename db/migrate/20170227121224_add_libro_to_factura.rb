class AddLibroToFactura < ActiveRecord::Migration[5.0]
  def change
    add_reference :facturas, :libro, foreign_key: true
  end
end
