require 'test_helper'

class ClientesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @cliente = clientes(:one)
    sign_in usuarios(:one)
  end

  test "should get index" do
    get clientes_url
    assert_response :success
  end

  test "should get new" do
    get new_cliente_url
    assert_response :success
  end

  test "should create cliente" do
    assert_difference('Cliente.count') do
      post clientes_url, params: { 
        cliente: { 
          identidad: "V-7484885", 
          nombres: "ROSA", 
          apellidos: "GARCIA", 
          direccion: "barquisimeto, estado lara", 
          fecha: "02/07/1995", 
          telefono: "0412-1254878"
        } 
      }
    end
    assert_redirected_to cliente_url(Cliente.last)
  end

  test "should show cliente" do
    get cliente_url(@cliente)
    assert_response :success
  end

  test "should get edit" do
    get edit_cliente_url(@cliente)
    assert_response :success
  end

  test "should update cliente" do
    patch cliente_url(@cliente), params: { 
      cliente: { 
        identidad: "V-7484885", 
        nombres: "ROSA", 
        apellidos: "GARCIA", 
        direccion: "barquisimeto, estado lara", 
        fecha: "02/07/1995", 
        telefono: "0412-1254878"
      } 
    }
    assert_redirected_to cliente_url(@cliente)
  end

  test "should destroy cliente" do
    assert_difference('Cliente.count', -1) do
      delete cliente_url(clientes(:to_destroy))
    end
    assert_redirected_to clientes_url
  end
end
