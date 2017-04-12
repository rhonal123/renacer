class LibroPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include LibrosHelper
  include ApplicationHelper

  def initialize(libro)
  	super(margin: 25)
  	@libro = libro
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    font_size 10
    encabezado()

	  grid([3,0 ], [3, 9]).bounding_box do
      _texto = "<b><i>LIBRO</b></i> N° #{codigo_contrato(@libro.id)}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
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

	  grid([4,0 ], [4, 3]).bounding_box do
      _texto = "MES: #{meses_libro(@libro.mes)}"
      indent(10) do
  	    text _texto, :valign => :center, :inline_format => true
	    end
      stroke_bounds
    end

	  grid([4,4], [4, 6]).bounding_box do
      _texto = "ANO: #{@libro.ano}"
      indent(10) do
	      text _texto, :valign => :center, :inline_format => true
	  	end 
      stroke_bounds
    end

	  grid([4,7], [4,9]).bounding_box do
      _texto = "Declarado: #{@libro.declarado? ? 'DECLARADO' : 'NO DECLARADO'}"
      indent(10) do
	      text _texto, :valign => :center, :inline_format => true
  		end 
 	    stroke_bounds
    end
		grid([5,0], [5,9]).bounding_box do
      _texto = "<i><b>DETALLE</b></i>"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
 	  end 

 	  #grid([7,0], [15,9]).bounding_box do
      titulo = [ "Id","Fecha","Tipo","Total","Estado"]
			tabla = []
			tabla << titulo 
			@libro.facturas.order(:id).each do |factura| 
				arr = []
				arr << factura.id
        arr << factura.fecha
        arr << factura.tipo
        arr << moneda_venezuela(factura.total)
        arr << factura.estado
			  tabla << arr  
			end
			table tabla,:header => true,
				 :width => 560,
				 :position => :center 
      move_down(10)
	    _texto = "<i><b>Base</b>#{moneda_venezuela(@libro.base)}</i>"
	    text _texto, :align=> :right, :inline_format => true
      move_down(5)
      _texto = "<i><b>Total</b>#{moneda_venezuela(@libro.total)}</i>"
      text _texto, :align=> :right, :inline_format => true
	  #end
  end 
end
