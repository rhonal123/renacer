class FacturasController < ApplicationController
  before_action :set_factura, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /facturas
  # GET /facturas.json
  def index
    @facturas = Factura.search(params[:page], params[:search], params[:sort],params[:desde],params[:hasta])
  end

  # GET /facturas/1
  # GET /facturas/1.json
  def show
  end


  def productos 
    @search = params[:search]
    @search = @search[:value] if @search.instance_of?(ActionController::Parameters)    
    @start =  params[:start]
    @length = params[:length]
    @productos = Producto.search(@start,@length,@search,params[:sort])
    @draw = params[:draw].to_i 
  end 

  # GET /facturas/new
  def new
    @factura = Factura.new()
    @factura.fecha = Date.today
    @factura.impuesto = Impuesto.iva params[:impuesto_id]
  end

  # POST /facturas
  # POST /facturas.json
  def create
    @factura = Factura.new(factura_params)
    if @factura.save()
      redirect_to @factura, notice: 'Factura fue creado correctamente.'
    else
      puts @factura.errors.full_messages
      render :new
    end 
  end

  def anular
    @factura = Factura.find(params[:factura_id])
    if @factura.anular()
      redirect_to @factura, notice: 'Factura anulada correctamente.'
    else
      flash[:error] = @factura.errors.full_messages
      redirect_to @factura 
    end 
  end

  def imprimir
    @factura = Factura.find(params[:factura_id])
    pdf = FacturaPdf.new @factura
    send_data pdf.render,filename: "factura_#{@factura.id}.pdf", type: 'application/pdf',disposition: 'inline'
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_factura
      @factura = Factura.detalle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def factura_params
      params.require(:factura).permit(
          :fecha,
          :tipo,
          :observacion,
          :cliente_fiscal_id,
          :telefono,
          :direccion,
          :impuesto_id,
          :nota,
          :monto_impuesto,
          detalles_attributes:[:producto_id, :cantidad ])
    end
end
