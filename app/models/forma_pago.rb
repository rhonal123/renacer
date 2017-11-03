class FormaPago < ApplicationRecord
  belongs_to :recibo, inverse_of: :pagos
  belongs_to :cuenta , optional: true
  validates :fecha,     presence: {message: 'Ingrese Fecha'}
  validates :monto,     presence: {message: 'Ingrese Monto'}
  validates :estado,    presence: {message: 'Ingrese Estado'}
  
  self.per_page = 12 
end
