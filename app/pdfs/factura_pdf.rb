class FacturaPdf < Prawn::Document
 include ActionView::Helpers::NumberHelper
  include FacturasHelper
  include ApplicationHelper

  def initialize(factura)
  	super(margin: 25)
  	@factura = factura
    define_grid(:columns => 10, :rows => 20, :gutter => 0)
    font_size 10
	  grid([3,0 ], [3, 9]).bounding_box do
      _texto = "<b><i>FACTURA </b></i> N° #{codigo_factura(@factura.id)}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end
    #grid.show_all
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

		#grid([6,0], [6,9]).bounding_box do
    #  _texto = "<i><b>DETALLE</b></i>"
    #  text _texto, :align=> :center , :valign => :center, :inline_format => true
 	  #end 

 	  grid([6,0], [15,9]).bounding_box do
      titulo = ["CODIGO","PRODUCTO","CANTIDAD","UNITARIO","PRECIO"]
			tabla = []
			tabla << titulo 
			@factura.detalles.order(:id).each do |detalle| 
				arr = []
				arr << codigo_detalle(detalle.producto.id) 
				arr << detalle.producto.descripcion
				arr << detalle.cantidad
				arr << moneda_venezuela(detalle.precio_unitario)
				arr << moneda_venezuela(detalle.precio)
  		  tabla << arr  
			end
			table tabla,:header => true,
				 :width => 560,
				 :column_widths	=> [50,290,60,80,80],
				 :cell_style => {size: 8, height: 17, padding:  [1,1, 0, 0], aligns: [:center,:center,:center,:center,:center] },
				 :position => :center 
        move_down(10)
	end

  grid([16,6], [18,9]).bounding_box do
    cell_1 = make_cell(content: "Base :") 
    cell_2 = make_cell(content: moneda_venezuela(@factura.base)) 
    cell_3 = make_cell(content: "#{@factura.impuesto.descripcion} :")
    cell_4 = make_cell(content: moneda_venezuela(@factura.monto_impuesto))
    cell_5 = make_cell(content: "Total :") 
    cell_6 = make_cell(content: moneda_venezuela(@factura.total)) 

    table [
        [cell_1,cell_2],
        [cell_3,cell_4],
        [cell_5,cell_6]
      ], cell_style: { borders: [] }

  #  _texto = "<i><b>Base :</b>#{moneda_venezuela(@factura.base)}</i>"
  #  text _texto, :align=> :right ,:inline_format => true
  #  _texto = "<i><b>#{@factura.impuesto.descripcion} :</b>#{moneda_venezuela(@factura.monto_impuesto)}</i>"
  #  text _texto, :align=> :right ,:inline_format => true
  #  _texto = "<i><b>Total :</b>#{moneda_venezuela(@factura.total)}</i>"
  #  text _texto, :align=> :right ,:inline_format => true
  end




  end 

end
