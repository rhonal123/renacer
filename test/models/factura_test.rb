require 'test_helper'

class FacturaTest < ActiveSupport::TestCase
  


  test "the truth" do
 		factura = Factura.factura_nueva({ 
      tipo: "CONTADO",
      fecha: Date.today,
      observacion: nil,
      cliente_fiscal_id: 1,
      direccion: "ddddddddd",
      impuesto_id: 1,
      estado: "PENDIENTE"
		})
		p1 = Producto.find(1)
		p2 = Producto.find(2)
		factura.calcular_montos()
		factura.agregar(p1)
		factura.agregar(p2)
		factura.detalles[0].cantidad = 10
		factura.detalles[1].cantidad = 10
		#puts factura.detalles
		factura.save 
		assert(factura.errors.empty?, "errors factura -> #{factura.errors.to_json}")
		assert factura.created_at?
  end
end
