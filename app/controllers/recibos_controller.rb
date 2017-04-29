class RecibosController < ApplicationController
  before_action :set_recibo, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /recibos/1
  # GET /recibos/1.json
  def show
  end

  # GET /recibos/new
  def new
    @factura = Factura.find(params[:factura_id])
    @recibo = Recibo.new
    @recibo.factura = @factura
    @recibo.cliente_fiscal_id = @factura.cliente_fiscal_id
    @recibo.fecha = Date.today 
    @recibo.pagos << FormaPago.new(monto: 0, fecha: Date.today)
    if(@factura.cancelada?)
      flash[:error] = "No Puedes crear recibo para esta factura #{@factura.id} esta cancelada."
      redirect_to @factura 
    end 
  end

  def agregar
    @factura = Factura.find(params[:factura_id])
    @recibo = Recibo.new(recibo_params)
    @recibo.factura = @factura
    @recibo.cliente_fiscal_id = @factura.cliente_fiscal_id
    @recibo.fecha = Date.today 
    @recibo.pagos <<  FormaPago.new(monto: 0, fecha: Date.today)
  end 

  # POST /recibos
  # POST /recibos.json
  def create
    @factura = Factura.find(params[:factura_id])
    @recibo = Recibo.crear_recibo(recibo_params,@factura)
    if @recibo.errors.empty?
      redirect_to @factura, notice: 'recibo creado correctamente.'
    else
      render :new
    end
  end

  def anular
    @recibo = Recibo.find(params[:recibo_id])
    if @recibo.anular()
      redirect_to  @recibo.factura, notice: 'Recibo anulado correctamente.'
    else
      flash[:error] = 'Error al anular la recibo.'
      redirect_to  @recibo.factura
    end 
  end 


  def imprimir
    @recibo = Recibo.find(params[:recibo_id])
    pdf = ReciboPdf.new @recibo
    send_data pdf.render,filename: "recibo_#{@recibo.id}", type: 'application/pdf',disposition: 'inline'
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recibo
      @recibo = Recibo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recibo_params
      params.require(:recibo).permit(
          :fecha,
          :concepto,
           pagos_attributes:[:fecha,:monto,:tipo,:referencia])
    end
end
 