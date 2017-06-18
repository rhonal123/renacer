class Pago < ApplicationRecord
  belongs_to :contrato , inverse_of: :pagos
  belongs_to :plan, optional: true   
  belongs_to :cobrador, required: false

  enum estado: {
  	pendiente: "pendiente",
  	pagado: "pagado",
  	anulado: "anulado"
 	}

  def pagar()
    if validar_pago?
      transaction do
        update!(
          estado: Pago.estados[:pagado],
          cobrador: contrato.cobrador,
          fecha_pago: Date.today
        )
        contrato.update!(
          monto: contrato.pagos.monto_pendiente
        )
      end 
    end 
  end   

  def self.pagados(desde,hasta)
    Pago.where(estado: estados[:pagado]).where(fecha_pago: desde..hasta)
  end 
  
  private 
    def validar_pago?()
      errors.add(:estado,"El Contrado debe estar Activo") unless contrato.activo?
      errors.add(:estado,"El Pago debe estar pendiente") unless pendiente?
      errors.empty?
    end 

end