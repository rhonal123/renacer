class Pago < ApplicationRecord
  belongs_to :contrato , inverse_of: :pagos
  def self.pagados(desde,hasta)
    Pago.where(estado: "pagado").where(fecha_pago: desde..hasta)
  end 
end
