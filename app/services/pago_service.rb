class PagoService
  attr_reader :pago

  def initialize(pago)
    @pago = pago
  end

  def pagar
    if pago.valid?(:pagar)
      pago.transaction do
        pago.update!(
          estado: Pago.estados[:pagado],
          cobrador: pago.contrato.cobrador,
          fecha_pago: Date.today)
        pago.contrato.update!( monto: pago.contrato.pagos.monto_pendiente ) if  Date.today.year == pago.ano
        true
      end 
    end  
  end   
end 