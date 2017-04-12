require 'test_helper'

class ClientesFiscalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cliente_fiscal = clientes_fiscales(:one)
  end

  test "should get index" do
    get clientes_fiscales_url
    assert_response :success
  end

  test "should get new" do
    get new_cliente_fiscal_url
    assert_response :success
  end

  test "should create cliente_fiscal" do
    assert_difference('ClienteFiscal.count') do
      post clientes_fiscales_url, params: { cliente_fiscal: { direccion: @cliente_fiscal.direccion, identidad: @cliente_fiscal.identidad, nombres: @cliente_fiscal.nombres } }
    end

    assert_redirected_to cliente_fiscal_url(ClienteFiscal.last)
  end

  test "should show cliente_fiscal" do
    get cliente_fiscal_url(@cliente_fiscal)
    assert_response :success
  end

  test "should get edit" do
    get edit_cliente_fiscal_url(@cliente_fiscal)
    assert_response :success
  end

  test "should update cliente_fiscal" do
    patch cliente_fiscal_url(@cliente_fiscal), params: { cliente_fiscal: { direccion: @cliente_fiscal.direccion, identidad: @cliente_fiscal.identidad, nombres: @cliente_fiscal.nombres } }
    assert_redirected_to cliente_fiscal_url(@cliente_fiscal)
  end

  test "should destroy cliente_fiscal" do
    assert_difference('ClienteFiscal.count', -1) do
      delete cliente_fiscal_url(@cliente_fiscal)
    end

    assert_redirected_to clientes_fiscales_url
  end
end
