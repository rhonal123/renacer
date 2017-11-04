class CuentaPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include LibrosHelper
  include FacturasHelper 
  include ApplicationHelper

  def initialize(cuenta,mes,ano)
  	super(margin: 25)
  	@cuenta = cuenta
    @mes = mes.to_i
    @ano = ano.to_i
    @fecha  = Date.new @ano, @mes, 1 
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    font_size 10
    encabezado()

	  grid([3,0 ], [3, 7]).bounding_box do
      _texto = """ 
        <b><i> Cuenta </b></i> N° #{cuenta.cuenta} #{cuenta.banco.banco}  
        """
      text _texto,:valign => :center, :inline_format => true
    end

    grid([3,7 ], [3, 10]).bounding_box do
      _texto = """ 
             #{meses_libro(@mes)} -- #{ano}
        """
      text _texto,:valign => :center, :inline_format => true
    end
    datos()
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
  end 


  def datos
    pagos = @cuenta.pagos @mes, @ano 

 	  #grid([7,0], [15,9]).bounding_box do
      titulo = [ "Factura","Recibo","Referencia","Tipo","Fecha","Monto"]
			tabla = []
			tabla << titulo 
			pagos.each do |p| 
				arr = []
				arr << codigo_factura(p.recibo.factura_id)
        arr << p.recibo_id
        arr << p.referencia
        arr << p.tipo
        arr << p.fecha 
        arr << moneda_venezuela(p.monto)
			  tabla << arr  
			end
			table tabla,:header => true,
				 :width => 560,
				 :position => :center 
      move_down(10)
	    _texto = "<i><b>Total : </b>#{moneda_venezuela(@cuenta.monto_acumuado(@mes,@ano))}</i>"
	    text _texto, :align=> :right, :inline_format => true
	  #end

  end 
end
