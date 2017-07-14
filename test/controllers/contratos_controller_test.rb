require 'test_helper'

class ContratosControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @contrato = contratos(:one)
    sign_in usuarios(:one)
  end

  test "should get index" do
    get contratos_url
    assert_response :success
  end

  test "should get new" do
    get new_contrato_url
    assert_response :success
  end

  test "should create contrato" do
    assert_difference('Contrato.count') do
      post contratos_url, params: { 
        contrato: { 
          cliente_id: @contrato.cliente_id,
          desde: @contrato.desde,
          hasta: @contrato.hasta, 
          monto: @contrato.monto, 
          plan_id: @contrato.plan_id,
          fecha_registro: "15/08/2016",
          cobrador_id: cobradores(:one).id
          }
      }
    end

    assert_redirected_to contrato_url(Contrato.last)
  end

  test "should show contrato" do
    get contrato_url(@contrato)
    assert_response :success
  end

  test "should get edit" do
    get edit_contrato_url(@contrato)
    assert_response :success
  end

  test "should update contrato" do
    patch contrato_url(@contrato), params: { 
      contrato: { 
        cliente_id: @contrato.cliente_id,
        desde: @contrato.desde,
        hasta: @contrato.hasta, 
        monto: @contrato.monto, 
        plan_id: @contrato.plan_id, 
        total: @contrato.total }
      }
    assert_redirected_to contrato_url(@contrato)
  end

  test "should destroy contrato" do
    delete contrato_url(@contrato)
    assert_redirected_to contratos_url
  end

  test "should change plan" do
    post contrato_plan_url(@contrato), params: {
      contrato:{
        plan_id: planes(:one).id
      }
    }
    assert_redirected_to contrato_url(@contrato)
    assert_equal 'Contrato fue correctamente Actualizado.', flash[:notice]

    post contrato_plan_url(@contrato), params: {
      contrato:{
        plan_id: 7896000456123
      }
    }
    assert_response :unprocessable_entity
    assert_equal ["Estado este plan ah sido eliminado."], flash[:error]
  end

  test "should generate proximo periodo" do 
    desde = @contrato.desde 
    travel_to desde.next_year do
      post contrato_generar_pagos_url @contrato
      assert_redirected_to contrato_url @contrato 
      assert_equal "Pagos Generados del ano #{desde.next_year.year}", flash[:notice]
    end

    @contrato_fail = contratos(:fails)
    desde = @contrato_fail.desde 
    travel_to desde.next_year do
      post contrato_generar_pagos_url @contrato_fail
      assert_response :unprocessable_entity
      assert_equal ["Estado No puedes generar pagos a un contrato anulado o vencido"], flash[:error]
    end
    #same year 
    @contrato = contratos(:fails)
    desde = @contrato.desde 
    post contrato_generar_pagos_url @contrato
    assert_response :unprocessable_entity
    assert_equal ["Estado No puedes generar pago de este año, dado que es el año entransito del contrato.", 
      "Estado No puedes generar pagos a un contrato anulado o vencido"], flash[:error]

    desde = @contrato.desde 
    travel_to desde.last_year do
      post contrato_generar_pagos_url @contrato
      assert_equal ["Estado No puedes generar pago de este año, dado que es el año entransito del contrato.", 
      "Estado No puedes generar pagos a un contrato anulado o vencido"], flash[:error]
    end
  end 

end
