class ContratosController < ApplicationController
  before_action :set_contrato, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :pagar,
    :pagos,
    :activar,
    :inactivar,
    :plan,
    :plan_edit,
    :generar_pagos
  ]
  before_action :authenticate_usuario!
  include ContratosHelper

  # GET /contratos
  # GET /contratos.json
  def index
    @contratos = Contrato.search(params[:page], params[:search], params[:sort])
  end

    # GET /contratos
  # GET /contratos.json
  def activos
    @contratos = Contrato.where(estado: :activo).search(params[:page], params[:search], params[:sort])
  end

      # GET /contratos
  # GET /contratos.json
  def inactivos
    @contratos = Contrato.where(estado: :inactivo).search(params[:page], params[:search], params[:sort])
  end

  def creados
    @contratos = Contrato.where(estado: :creado).search(params[:page], params[:search], params[:sort])
  end
    
  def anulados
    @contratos = Contrato.where(estado: :anulado).search(params[:page], params[:search], params[:sort])
  end
    
  


  # GET /contratos/1
  # GET /contratos/1.json
  def show
  end

  # GET /contratos/new
  def new
    @contrato = Contrato.new
  end

  # GET /contratos/1/edit
  def edit
  end

  # POST /contratos
  # POST /contratos.json
  def create
    @contrato = Contrato.new(contrato_params)
    if @contrato.save()
      redirect_to @contrato, notice: 'Contrato fue correctamente creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
    unless @contrato.anulado?
      if @contrato.update(contrato_params)
        redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.'
      else
       render :edit
      end
    else
      @error = "Este Contrato no puede ser Editado se encuentra #{@contrato.estado}"
      render :edit
    end
  end

  # DELETE /contratos/1
  # DELETE /contratos/1.json
  def destroy
    ContratoService.new(@contrato).anular 
    if @contrato.anulado?
      redirect_to contratos_url, notice: 'Contrato anulado'
    else
      flash[:error] = @contrato.errors.full_messages
      redirect_to contratos_url
    end 
  end

  def pagos

  end 

  def pagar 
    @pago = @contrato.pagos.find(params[:pago_id])
    @response = PagoService.new(@pago).pagar() 
    respond_to do |format|
      format.html do
        if @response
          redirect_to @contrato, notice: 'Contrato Actualizado'
        else
          flash[:error] = @pago.errors.full_messages
          redirect_to @contrato 
        end 
      end 
      format.js
    end
  end 

  def activar 
    ContratoService.new(@contrato).activar 
    if @contrato.activo?
      redirect_to @contrato, notice: 'Contrato Activado'
    else 
      flash[:error] = @contrato.errors.full_messages
      redirect_to @contrato, notice: 'Error al activar el contrato'
    end 
  end 

  def inactivar 
    ContratoService.new(@contrato).inactivar 
    if @contrato.inactivo?
      redirect_to @contrato, notice: 'Contrato Inactivo'
    else 
      flash[:error] = @contrato.errors.full_messages
      redirect_to @contrato, notice: 'Error al inactivar el contrato'
    end 
  end 


  def cobrador
    @contrato = Contrato.find(params[:contrato_id])
    if @contrato.update(cobrador_params)
       redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.' 
    else
      flash[:error] = @contrato.errors.full_messages
      render :show
    end
  end 

  def cobrador_edit
    @contrato = Contrato.find(params[:contrato_id])
  end 

  def propietario_edit
    @contrato = Contrato.find(params[:contrato_id])
  end 

  def propietario
    @contrato = Contrato.find(params[:contrato_id])
    if @contrato.update(propietario_params)
       redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.' 
    else
      render :cobrador_edit
    end
  end 
  
  def fecha_registro
    @contrato = Contrato.find(params[:contrato_id])
    if @contrato.update(fecha_registro_params)
       redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.' 
    else
      render :fecha_registro_edit
    end
  end 

  def fecha_registro_edit
    @contrato = Contrato.find(params[:contrato_id])
  end 

  def contrato 
    @contrato = Contrato.find(params[:contrato_id])
    @monto = @contrato.plan.monto
    pdfcontra = ContratoPdf.new @contrato
    if @contrato.plan.reporte.path.nil?
      return send_data(pdfcontra.render,filename: "contrato_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline')
    else
      pdf = CombinePDF.new
      pdf << CombinePDF.parse(pdfcontra.render)
      pdf << CombinePDF.load(@contrato.plan.reporte.path)
      pdf.number_pages number_format: "CONTRATO: #{codigo_contrato @contrato.id} -- pagina: %s",
        number_location:  [:top_right],
        margin_from_height: 25,
        font_size: 10 
      return send_data(pdf.to_pdf,filename: "contrato_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline')
    end 
  end 

  def catulina 
    @contrato = Contrato.find params[:contrato_id]
    @monto = @contrato.plan.monto
    @type  = params[:type]
    pdf    = nil 
    if @type == 'year'  then 
      pdf = CartulinaAnoPdf.new @contrato
    else
      pdf = CartulinaPdf.new @contrato
    end 
    send_data pdf.render,filename: "contrato_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline'
  end 

  def carnet 
    @contrato = Contrato.find(params[:contrato_id])
    pdf = CarnetPdf.new [@contrato]
    send_data pdf.render,filename: "carnet_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline'
  end 

  def generar_pagos
    @service = ContratoService.new(@contrato)
    @service.generar_pagos_proximo_periodo
    if @service.no_error?
      redirect_to @contrato, notice: "Pagos Generados del ano #{@contrato.desde.year}"
    else
       flash[:error] = @contrato.errors.full_messages 
       render :show ,status: :unprocessable_entity
    end 
  end 

  def pagos_cobrados 
    datos = pagos_cobrados_params()
    @desde = datos[:desde]
    @hasta = datos[:hasta]
    @pagos = Pago.pagados(@desde,@hasta)
    pdf = PagosPdf.new @pagos, @desde,@hasta
    send_data pdf.render,filename: "pagos", type: 'application/pdf',disposition: 'inline'
  end 

  def plan_edit

  end 

  def plan
    @service = ContratoService.new(@contrato)
    @service.cambiar_plan plan_params[:plan_id]
    if @service.no_error?
       redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.' 
    else
       flash[:error] = @contrato.errors.full_messages 
       render :show ,status: :unprocessable_entity
    end
  end   

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contrato
      @contrato = Contrato.find(params[:id] || params[:contrato_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_params
      params.require(:contrato).permit(:cliente_id, :plan_id, :desde,:cobrador_id,:fecha_registro)
    end

    def pagos_cobrados_params()
      params.permit(:desde, :hasta)
    end

    def propietario_params
      params.require(:contrato).permit(:cliente_id)
    end
    
    def plan_params
      params.require(:contrato).permit(:plan_id)
    end
  
    def fecha_registro_params
      params.require(:contrato).permit(:fecha_registro)
    end

    def cobrador_params
      params.require(:contrato).permit(:cobrador_id)
    end

end
