require 'test_helper'

class CobradoresControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @cobrador = cobradores(:one)
    sign_in usuarios(:one)
  end

  test "should get index" do
    get cobradores_url
    assert_response :success
  end

  test "should get new" do
    get new_cobrador_url
    assert_response :success
  end

  test "should create cobrador" do
    assert_difference('Cobrador.count') do
      post cobradores_url, params: { 
        cobrador: { 
          identidad: "V-7894587", 
          nombre: "Sou Camejo" 
        }
      }
    end

    assert_redirected_to cobrador_url(Cobrador.last)
  end

  test "should show cobrador" do
    get cobrador_url(@cobrador)
    assert_response :success
  end

  test "should get edit" do
    get edit_cobrador_url(@cobrador)
    assert_response :success
  end

  test "should update cobrador" do
    patch cobrador_url(@cobrador), params: { cobrador: { identidad: @cobrador.identidad, nombre: @cobrador.nombre } }
    assert_redirected_to cobrador_url(@cobrador)
  end

  test "should destroy cobrador" do
    assert_difference('Cobrador.count', -1) do
      delete cobrador_url(cobradores(:cobrador_delete))
    end
    assert_redirected_to cobradores_url
  end
end
