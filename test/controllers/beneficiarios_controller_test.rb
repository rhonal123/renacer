require 'test_helper'

class BeneficiariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beneficiario = beneficiarios(:one)
  end

  test "should get index" do
    get beneficiarios_url
    assert_response :success
  end

  test "should get new" do
    get new_beneficiario_url
    assert_response :success
  end

  test "should create beneficiario" do
    assert_difference('Beneficiario.count') do
      post beneficiarios_url, params: { beneficiario: {  } }
    end

    assert_redirected_to beneficiario_url(Beneficiario.last)
  end

  test "should show beneficiario" do
    get beneficiario_url(@beneficiario)
    assert_response :success
  end

  test "should get edit" do
    get edit_beneficiario_url(@beneficiario)
    assert_response :success
  end

  test "should update beneficiario" do
    patch beneficiario_url(@beneficiario), params: { beneficiario: {  } }
    assert_redirected_to beneficiario_url(@beneficiario)
  end

  test "should destroy beneficiario" do
    assert_difference('Beneficiario.count', -1) do
      delete beneficiario_url(@beneficiario)
    end

    assert_redirected_to beneficiarios_url
  end
end
