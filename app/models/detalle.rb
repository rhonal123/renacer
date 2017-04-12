class Detalle < ApplicationRecord
  belongs_to :factura,  inverse_of: :detalles
  belongs_to :producto 

  validates :cantidad, 
    presence: {message: 'Ingrese Cantidad .'},
    numericality: { greater_than: 0, message: "La cantidad debe ser mayor que 0." }
  validates :producto_id, presence: {message: 'Ingrese Producto id .'}
  validates :precio, presence: {message: 'Ingrese Precio.'}
  validates :precio_unitario, presence: {message: 'Ingrese Precio Unitario.'}
end