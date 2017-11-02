require 'test_helper'

class ImpuestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @impuesto = impuestos(:one)
  end

  test "should get index" do
    get impuestos_url
    assert_response :success
  end

  test "should get new" do
    get new_impuesto_url
    assert_response :success
  end

  test "should create impuesto" do
    assert_difference('Impuesto.count') do
      post impuestos_url, params: { impuesto: {  } }
    end

    assert_redirected_to impuesto_url(Impuesto.last)
  end

  test "should show impuesto" do
    get impuesto_url(@impuesto)
    assert_response :success
  end

  test "should get edit" do
    get edit_impuesto_url(@impuesto)
    assert_response :success
  end

  test "should update impuesto" do
    patch impuesto_url(@impuesto), params: { impuesto: {  } }
    assert_redirected_to impuesto_url(@impuesto)
  end

  test "should destroy impuesto" do
    assert_difference('Impuesto.count', -1) do
      delete impuesto_url(@impuesto)
    end

    assert_redirected_to impuestos_url
  end
end
