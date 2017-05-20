class Pago < ApplicationRecord
  belongs_to :contrato , inverse_of: :pagos
  belongs_to :plan, optional: true   
  belongs_to :cobrador, required: false

  def self.pagados(desde,hasta)
    Pago.where(estado: "pagado").where(fecha_pago: desde..hasta)
  end 
end