require 'test_helper'

class FacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
  end

#  test "should get index" do
#    get facturas_url
#    assert_response :success
#  end

#  test "should get new" do
#    get new_factura_url
#    assert_response :success
#  end

  test "should create factura" do
    #assert_difference('Factura.count') do
    post facturas_url, params: {
      factura: { 
          "cliente_fiscal": 1,
          "tipo": "CONTADO",
          "direccion": "casa 1 ",
          "detalles": [
              {"producto_id":1,"cantidad":1},
              {"producto_id":2,"cantidad":1},
              {"producto_id":3,"cantidad":1}]
        }
      }
    factura = assigns(:factura)
    assert factura.erros.empty?," factura con errores #{factura.errors.full_message}"
    #end
    #assert_redirected_to factura_url(Factura.last)
  end

#  test "should show factura" do
#    get factura_url(@factura)
#    assert_response :success
#  end

#  test "should get edit" do
#    get edit_factura_url(@factura)
#    assert_response :success
#  end

#  test "should update factura" do
#    patch factura_url(@factura), params: { factura: { base: @factura.base, clienteFiscal_id: @factura.clienteFiscal_id, direccion: @factura.direccion, estado: @factura.estado, fecha: @factura.fecha, observacion: @factura.observacion, saldo: @factura.saldo, tipo: @factura.tipo, total: @factura.total } }
#    assert_redirected_to factura_url(@factura)
#  end

#  test "should destroy factura" do
#    assert_difference('Factura.count', -1) do
#      delete factura_url(@factura)
#    end
#    assert_redirected_to facturas_url
#  end
end
