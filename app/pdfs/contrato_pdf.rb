class ContratoPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(contrato)
    super( margin: 25)
    @contrato = contrato
    font_size 9
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    #grid.show_all
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
  end 


  def cuerpo 

	  grid([3,0 ], [3, 9]).bounding_box do
      _texto = "<b><i>CONTRATO DE SERVICIOS FUNERARIOS</b></i>\n CONTRATO N° #{codigo_contrato(@contrato.id)}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
       
    end

	  grid([4,0 ], [4, 3]).bounding_box do
      _texto = "PLAN: #{@contrato.plan.nombre}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([4,4], [4, 6]).bounding_box do
      _texto = "MONTO: #{moneda_venezuela @contrato.total}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([4,7], [4,9]).bounding_box do
      _texto = "SEMANAL: #{moneda_venezuela @contrato.plan.monto}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([5,0 ], [5, 3]).bounding_box do
      _texto = "FECHA INICIO: #{@contrato.desde}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([5,4], [5, 6]).bounding_box do
      _texto = "AÑO VIGENCIA: #{@contrato.desde.year}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([5,7], [5,9]).bounding_box do
      _texto = "FECHA REGISTRO: #{@contrato.fecha_registro}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

 	  grid([6,0], [6,9]).bounding_box do
      _texto = "CONTRATANTE"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end
    
    grid([7,0 ], [7, 3]).bounding_box do
      _texto = "APELLIDOS: #{@contrato.cliente.apellidos}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
			stroke_bounds
    end
	  
	  grid([7,4], [7, 6]).bounding_box do
      _texto = "NOMBRES: #{@contrato.cliente.nombres}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
	    stroke_bounds
    end
	
	  grid([7,7], [7,9]).bounding_box do
      _texto = "IDENTIDAD: #{@contrato.cliente.identidad}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
	  	stroke_bounds
    end

    grid([8,0 ], [8, 3]).bounding_box do
      _texto = "FECHA NACIMIENTO: #{@contrato.cliente.fecha}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
  		stroke_bounds
    end

	  grid([9,0], [9, 3]).bounding_box do
      _texto = "TELEFONO: #{@contrato.cliente.telefono}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

	  grid([8,4], [9, 9]).bounding_box do
      _texto = "DIRECCION: #{@contrato.cliente.direccion}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
      stroke_bounds
    end

    grid([10,0], [10,9]).bounding_box do
      _texto = "BENEFICIARIOS"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end

    grid([11,0], [18,9]).bounding_box do
      titulo = ["IDENTIDAD","APELLIDOS","NOMBRES","FECHA NACIMIENTO","PARENTESCO"]
			tabla = []
			tabla << titulo 
			@contrato.beneficiarios.order(:id).each do |beneficiario| 
				arr = []
				arr << beneficiario.identidad
				arr << beneficiario.apellidos
				arr << beneficiario.nombres 
				arr << beneficiario.fechaNacimiento  
			  arr << beneficiario.parentesco 
			  tabla << arr  
			end
			table tabla,:header => true,
				 :width => 560,
				 #:column_widths	=> [40,60,80,460,80],
				 #:cell_style => {size: letra_sm-3},
				 :position => :center 
    end

    grid([18,1], [18,3]).bounding_box do
      line [30,15], [137,15]
      _texto = "EL CONTRATANTE"
      text _texto, :align=> :center , :valign => :bottom, :inline_format => true
    end

    grid([18,5], [18,7]).bounding_box do
      line [30,15], [137,15]
      _texto = "FIRMA AUTORIZADA"
      text _texto, :align=> :center , :valign => :bottom, :inline_format => true
    end

    stroke



  end 

 end
