require 'test_helper'

class RecibosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recibo = recibos(:one)
  end

  test "should get index" do
    get recibos_url
    assert_response :success
  end

  test "should get new" do
    get new_recibo_url
    assert_response :success
  end

  test "should create recibo" do
    assert_difference('Recibo.count') do
      post recibos_url, params: { recibo: {  } }
    end

    assert_redirected_to recibo_url(Recibo.last)
  end

  test "should show recibo" do
    get recibo_url(@recibo)
    assert_response :success
  end

  test "should get edit" do
    get edit_recibo_url(@recibo)
    assert_response :success
  end

  test "should update recibo" do
    patch recibo_url(@recibo), params: { recibo: {  } }
    assert_redirected_to recibo_url(@recibo)
  end

  test "should destroy recibo" do
    assert_difference('Recibo.count', -1) do
      delete recibo_url(@recibo)
    end

    assert_redirected_to recibos_url
  end
end
