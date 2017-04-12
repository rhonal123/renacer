class CuentaPorCobrarController < ApplicationController
  include ApplicationHelper
  include  ActionView::Helpers::NumberHelper 
	 # GET /cuenta por cobrar
  def index
  	@total = View::CuentaPorCobrar.sum(:porcobrar)
    @cuentas = View::CuentaPorCobrar.search(params[:page], params[:search], params[:sort])
  end
  def show
  	@cuenta = View::CuentaPorCobrar.find(params[:id])
  end 
end
