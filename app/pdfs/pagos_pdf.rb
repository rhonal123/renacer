class PagosPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(pagos,desde,hasta)
    super( margin: 25)
    @pagos = pagos 
    @desde = desde 
    @hasta = hasta 
    font_size 9
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    encabezado 
    cuerpo
  end
 

  def encabezado 
    l1 = "#{Rails.root}/public/Logo02.jpg"
    image l1, :at => [15,740],:width => 230, :height => 100


  	l2 = "#{Rails.root}/public/Logo02.jpg"
  	image l2, :position => :center, :vposition => :center

	  grid([0, 0], [2, 3]).bounding_box do
      _texto = "<b><i>Rif J-40219124-3</i></b>"
      text _texto, :align=> :center , :valign => :bottom, :inline_format => true
    end
	  grid([0,4 ], [2, 9]).bounding_box do
      _texto = """<font size='14'><b><i>SERVICIOS FUNERARIOS
EL NUEVO RENACER C.A.</i></b></font>
Carrera 33 con Av. Andres Bello entre Calle 21. Edif 
Sindicato de Hospitales y Clinica, Local 1, PB. Barquisimeto.
Teléfonos: 0251-415.83.86 / 0416-124.30.84 / 0414-525.03.01 / 0426-657.31.59 
"""
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end

    grid([3,0], [3, 4]).bounding_box do
      _texto = "<b><i> Reporte de Pago Realizados, Desde: #{@desde} hasta: #{@hasta}</i></b>"
      text _texto, :align=> :center , :valign => :bottom, :inline_format => true
    end
  end 


  def cuerpo 
    monto = 0.0
    #grid([4,0], [18,9]).bounding_box do
      titulo = ["CONTRATO","SEMANA","MONTO","FECHA PAGO"]
      tabla = []
      tabla << titulo 
      @pagos.each do |pago| 
        arr = []
        arr << codigo_contrato(pago.contrato_id)
        arr << pago.semana 
        arr << moneda_venezuela(pago.monto)   
        arr << pago.fecha_pago  
        tabla << arr  
        monto += pago.monto
      end
      table tabla,:header => true,
         :width => 560 
      _texto = "<b><i> Total Cobrado: </b></i> #{moneda_venezuela(monto)} "
      move_down(40)
      text _texto, :align=> :right, :inline_format => true
         #:column_widths  => [40,60,80,460,80],
         #:cell_style => {size: letra_sm-3},
         #:position => :center 
    #end

  end 

 end
