require 'test_helper'

class BeneficiariosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @beneficiario = beneficiarios(:one)
    @contrato = contratos(:one)
    sign_in usuarios(:one)
  end

  test "should get new" do
    get new_contrato_beneficiario_path(@contrato,:js),  xhr: true
    assert_response :success
  end

  test "should create beneficiario" do
    assert_difference('Beneficiario.count') do
      post  contrato_beneficiarios_path(@contrato), 
        params: { 
          beneficiario: { 
            identidad: "V-7847845",
            contrato_id: @contrato.id,
            apellidos: "RODRIGUEZ",
            nombres: "MARIA",
            fechaNacimiento: "26/08/1995",
            parentesco: "HERMANO" 
           }
        }
    end
    assert_response :success
  end

  test "should get edit" do
    get edit_contrato_beneficiario_path(@contrato,@beneficiario), xhr: true 
    assert_response :success
  end

  test "should update beneficiario" do
    patch contrato_beneficiario_url(@contrato,@beneficiario),
        params: { 
          beneficiario: { 
            identidad: "V-7847845",
            contrato_id: @contrato.id,
            apellidos: "RODRIGUEZ",
            nombres: "MARIA",
            fechaNacimiento: "26/08/1995",
            parentesco: "HERMANO" 
           }
        }
    assert_response :success
  end

  test "should destroy beneficiario" do
    assert_difference('Beneficiario.count', -1) do
      delete  contrato_beneficiario_path(@contrato,@beneficiario), xhr: true 
    end
    assert_response :success
  end
end
