class FacturaService 

  attr_reader :factura

  def initialize factura
    @factura = factura
  end

  def anular
    if @factura.valid? :anular 
      Factura.transaction do
 	 			@factura.update estado: "ANULADA",
 	 				base: 0,
      		total: 0,
      		saldo: 0,
      		monto_impuesto: 0,
      		porcentaje: 0
      end 
    end 
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