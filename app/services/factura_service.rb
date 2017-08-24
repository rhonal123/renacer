class FacturaService 

  attr_reader :factura

  def initialize factura
    @factura = factura
  end

  def anular

  end 

#  def self.crear(params)
#    factura = new(params)
#    factura.calcular_montos
#    return factura 
#  end 


  def no_error?
    @contrato.errors.empty?
  end 


end 