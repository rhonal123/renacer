class FacturaPdf < Prawn::Document
 include ActionView::Helpers::NumberHelper
  include FacturasHelper
  include ApplicationHelper

  def initialize(factura)
  	super(margin: 25)
  	@factura = factura
    define_grid(:columns => 12, :rows => 30, :gutter => 0)
    font_size 10

    grid([3,0 ], [3, 9]).bounding_box do
      _texto = "<b><i>FACTURA </b></i> N° #{codigo_factura(@factura.id)}"
      text _texto, :align=> :center , :valign => :center, :inline_format => true
    end
    #grid.show_all
    datos_cliente_factura()
  end


  def datos_cliente_factura

	  grid([4, 0], [5, 8]).bounding_box do
      cliente = "<b>CLIENTE:</b> #{@factura.cliente_fiscal.nombres[0..120]}"
      indent 10, 5 do
  	    text cliente,valign: :center, inline_format:  true
	    end
      stroke_bounds
    end

    grid([6,0 ], [6, 3]).bounding_box do
      _texto = "<b>RIF:</b> #{@factura.cliente_fiscal.identidad}"
      indent 10, 5  do
        text _texto, valign: :center, inline_format:  true
      end
      stroke_bounds
    end

    grid([6,4 ], [6, 8]).bounding_box do
      _texto = "<b>TELEFONO:</b> #{@factura.cliente_fiscal.telefono}"
      indent 10, 10  do
        text _texto,valign: :center, inline_format:  true
      end
      stroke_bounds
    end


    grid([7,0 ], [8, 11]).bounding_box do
      _direccion = "<b>DIRECCION:</b> #{@factura.cliente_fiscal.direccion[0..250]}"
      indent 10, 5 do
        text _direccion, valign: :center, inline_format:  true
      end
      stroke_bounds
    end

    grid([4,9], [6,11]).bounding_box do
      _text = " <b>EMISION:</b> #{@factura.fecha} \n <b>TIPO:</b>#{@factura.tipo}"
      indent(10) do
        text _text, align: :center, valign: :center, inline_format:  true
      end 
      stroke_bounds
    end

		grid([10,0], [10,11]).bounding_box do
      _texto = "<i><b>DETALLE</b></i>"
      indent(10) do
        text _texto, align: :center, valign: :center, inline_format: true
      end 
      stroke_bounds
 	  end 

 	  grid([11,0], [24,11]).bounding_box do
      titulo = ["CODIGO","PRODUCTO","CANT","UNITARIO","PRECIO"]
			tabla = []
			tabla << titulo 
			@factura.detalles.order(:id).each do |detalle| 
				arr = []
				arr << codigo_detalle(detalle.producto.id) 
				arr << detalle.producto.descripcion
				arr << detalle.cantidad
				arr << moneda(detalle.precio_unitario)
				arr << moneda(detalle.precio)
  		  tabla << arr  
			end
			table tabla,:header => true,
				 :width => 562,
				 :column_widths	=> [50,292,50,85,85],
				 :cell_style => { 
            size: 9,
            padding:  [3 ,4, 4, 3],
            align: :center,
          },
				 :position => :center 
       move_down(10)
      stroke_bounds
	   end

  grid([25,8], [27,11]).bounding_box do
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
      ],
      width: 187, 
      cell_style: {
          size: 9, 
          padding:  [5 ,5, 5, 5],
          align: :right
      } 
  end




  end 

end
