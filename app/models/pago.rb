class Pago < ApplicationRecord
  belongs_to :contrato , inverse_of: :pagos #, validate: true
  belongs_to :plan, optional: true   
  belongs_to :cobrador, required: false

  validates_with PagarValidator, on: :pagar

  enum estado: {
  	pendiente: "pendiente",
  	pagado: "pagado",
  	anulado: "anulado"
 	}

  def self.pagados(desde,hasta)
    Pago.where(estado: estados[:pagado]).where(fecha_pago: desde..hasta)
  end 

end