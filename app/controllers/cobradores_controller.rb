class CobradoresController < ApplicationController
  before_action :set_cobrador, only: [:show, :edit, :update, :destroy,:planilla_liquidacion,:pagar,:seleccionar_contrato,:pagar_pago]
  before_action :authenticate_usuario!

  # GET /cobradors
  # GET /cobradors.json
  def index
    @cobradores = Cobrador.search(params[:page], params[:search], params[:sort])
  end  

  # GET /cobradors/1
  # GET /cobradors/1.json
  def show
  end

  # GET /cobradors/new
  def new
    @cobrador = Cobrador.new
  end

  # GET /cobradors/1/edit
  def edit
  end

  # POST /cobradors
  # POST /cobradors.json
  def create
    @cobrador = Cobrador.new(cobrador_params)
    if @cobrador.save
      redirect_to @cobrador, notice: 'Cobrador creado correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /cobradors/1
  # PATCH/PUT /cobradors/1.json
  def update
    if @cobrador.update(cobrador_params)
      redirect_to @cobrador, notice: 'Cobrador fue correctamente actualizado.'
    else
      render :edit
    end
  end

  # DELETE /cobradors/1
  # DELETE /cobradors/1.json
  def destroy
    begin
      @cobrador.destroy
      redirect_to cobradores_url, notice: "#{@cobrador.nombres} fue Eliminado."
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error]  = "No Puedes Eliminar este Cobrador, esta siendo utilizado por contratos."
      redirect_to cobradores_url 
    end
  end

  def pagar
    @fecha = params[:fecha]
    @fecha = Date.today if @fecha.nil? 
    @fecha = @fecha.to_date
  end 

  def pagar_pago  
    @pago = Pago.find(params[:pago_id])
    @fecha = params[:fecha]
    @ano  = params[:ano]
    if  PagoService.new(@pago).pagar() 
      redirect_to  cobrador_seleccionar_contrato_path(@cobrador.id,@pago.contrato_id,{ fecha: @fecha, ano: @ano }), notice: 'Contrato Actualizado'
    else
      flash[:error] = @pago.errors.full_messages
      redirect_to  cobrador_seleccionar_contrato_path(@cobrador.id,@pago.contrato_id,{ fecha: @fecha, ano: @ano }), notice: 'Error '
    end
  end 

  def seleccionar_contrato
    @contrato = @cobrador.contratos.find(params[:idcontrato])
    @ano = params[:ano]
    @ano = Date.today.year if @ano.nil?
    @fecha = params[:fecha]
  end 

  def planilla_liquidacion
    #@totalizar_pagados = Pago.totalizar_pagos_pagados(params[:cobrador_id],params[:desde],params[:hasta])
    #@totalizar = Pago.totalizar_pagos(params[:cobrador_id],params[:desde],params[:hasta])
    #@pagos = Pago.all 
    pdf = PlanillaLiquidacionPdf.new(params)
    send_data pdf.render, 
      filename: "planilla_liquidacion#{@cobrador.id}",
      type: 'application/pdf',
      disposition: 'inline'
  end 



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cobrador
      @cobrador = Cobrador.find(params[:id] || params[:cobrador_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cobrador_params
      params.require(:cobrador).permit(:identidad, :nombre)
    end
end
