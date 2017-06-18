require 'test_helper'

class PlanesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @plan = planes(:one)
    sign_in usuarios(:one)
  end

  test "should get index" do
    get planes_path
    assert_response :success
  end

  test "should get new" do
    get new_plan_url
    assert_response :success
  end

  test "should create plan" do
    assert_difference('Plan.count') do
      post planes_url, params: { plan: { componentes: @plan.componentes, monto: @plan.monto, nombre: @plan.nombre } }
    end

    assert_redirected_to plan_url(Plan.last)
  end

  test "should show plan" do
    get plan_url(@plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_url(@plan)
    assert_response :success
  end

  test "should update plan" do
    patch plan_url(@plan), params: { plan: { componentes: @plan.componentes, monto: @plan.monto, nombre: @plan.nombre } }
    assert_redirected_to plan_url(@plan)
  end

  test "should destroy plan" do
    assert_difference('Plan.count', -1) do
      delete plan_url(@plan)
    end

    assert_redirected_to planes_url
  end
end
