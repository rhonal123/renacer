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
end
