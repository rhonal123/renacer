class FacturaPdf < Prawn::Document
 include ActionView::Helpers::NumberHelper
  include ContratosHelper
  include ApplicationHelper

  def initialize(factura)
  	super(margin: 25)
  	@factura = factura
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    font_size 10
	  grid([3,0 ], [3, 9]).bounding_box do
      _texto = "<b><i>FACTURA </b></i> N° #{codigo_contrato(@factura.id)}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end
    datos_cliente_factura()
  end



  def datos_cliente_factura

	  grid([4,0 ], [4, 3]).bounding_box do
      _texto = "CLIENTE: #{@factura.cliente_fiscal.nombres}"
      indent(10) do
  	    text _texto, :valign => :center, :inline_format => true
	    end
      stroke_bounds
    end

	  grid([4,4], [4, 6]).bounding_box do
      _texto = "RIF: #{@factura.cliente_fiscal.identidad}"
      indent(10) do
	      text _texto, :valign => :center, :inline_format => true
	  	end 
      stroke_bounds
    end

		grid([5,0 ], [5, 9]).bounding_box do
      _texto = " \t DIRECCION: #{@factura.cliente_fiscal.direccion}"
      indent(10) do
  	    text _texto, :valign => :center, :inline_format => true
	    end 
      stroke_bounds
    end

		grid([6,0], [6,9]).bounding_box do
      _texto = "<i><b>DETALLE</b></i>"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
 	  end 

 	  grid([7,0], [15,9]).bounding_box do
      titulo = ["CODIGO","PRODUCTO","CANTIDAD","PRECIO UNITARIO","PRECIO"]
			tabla = []
			tabla << titulo 
			@factura.detalles.order(:id).each do |detalle| 
				arr = []
				arr << detalle.producto.id 
				arr << detalle.producto.descripcion
				arr << detalle.cantidad
				arr << moneda_venezuela(detalle.precio_unitario)
				arr << moneda_venezuela(detalle.precio)
  		  tabla << arr  

			end
			table tabla,:header => true,
				 :width => 560,
				 #:column_widths	=> [40,60,80,460,80],
				 #:cell_style => {size: letra_sm-3},
				 :position => :center 
        move_down(10)
	      _texto = "<i><b>Base :</b>#{moneda_venezuela(@factura.base)}</i>"
	      text _texto, :align=> :right ,:inline_format => true
	      _texto = "<i><b>Total :</b>#{moneda_venezuela(@factura.total)}</i>"
	      text _texto, :align=> :right ,:inline_format => true
	    end
  end 

end
