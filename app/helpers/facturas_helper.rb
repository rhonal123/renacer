module FacturasHelper

	def codigo_factura(id)
		s = "000000#{id}" 
		s[s.size-6, s.size]
	end 


	def codigo_detalle(id)
		s = "000#{id}" 
		s[s.size-4, s.size]
	end 

	def quitar_producto_factura producto
		button_tag "Quitar",
	    class:   "btn btn-danger btn-sm",
	    type: "button",
	    onClick: "formFactura.quitarProducto(#{producto.id})"
	end 

	def proximo_valor 
    content_tag :label, 
    	"Numero asignar: #{codigo_factura(Factura.proxima_factura)}",
    	class: "label label-info pull-right",
    	style: "font-size: 125%;" 
	end 


	def opciones_cuentas_bancarias 
  	cuentas = Cuenta.all.collect{ |c| ["#{c.banco.banco} #{c.cuenta}",c.id] } 
		cuentas.insert(0,["EFECTIVO",nil])
		options_for_select(cuentas)
	end 


end
