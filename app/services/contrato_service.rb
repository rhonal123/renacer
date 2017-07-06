class ContratoService 

  attr_reader :contrato

  def initialize(contrato)
    @contrato = contrato
  end

  def anular
    if @contrato.valid? :anular 
      Contrato.transaction do
        @contrato.pagos.update_all(estado: Pago.estados[:anulado])
        @contrato.update! monto: 0.0, total: 0.0, estado: Contrato.estados[:anulado] 
      end 
    end 
  end 

  def activar  
    @contrato.activo! if @contrato.valid? :activar     
  end 

end 