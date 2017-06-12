class ContratosController < ApplicationController
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!
  include ContratosHelper

  # GET /contratos
  # GET /contratos.json
  def index
    @contratos = Contrato.search(params[:page], params[:search], params[:sort])
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
    @contrato.hasta =  Date.new(Date.today.year,12,31)
    if @contrato.guardar_contrato()
      redirect_to @contrato, notice: 'Contrato fue correctamente creado.'
    else
      render :new
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
    unless @contrato.estado ==  "ANULADO"
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
    #@contrato.destroy
    @contrato.anular()
    redirect_to contratos_url, notice: 'Contrato fue correctamente anulado'
  end

  def pagos
    @contrato = Contrato.find(params[:contrato_id])
  end 

  def pagar 
    @contrato = Contrato.find(params[:contrato_id])
    @contrato.pagar(params[:pago_id])
    redirect_to @contrato, notice: 'Contrato Actualizado'
  end 

  def activar 
    @contrato = Contrato.find(params[:contrato_id])
    @contrato.activar()
    if @contrato.estado == "ACTIVO"
      redirect_to @contrato, notice: 'Contrato Activado'
    else 
      redirect_to @contrato, notice: 'Error al activar el contrato'
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
    @contrato = Contrato.find(params[:contrato_id])
    @monto = @contrato.plan.monto
    pdf = CartulinaPdf.new @contrato
    send_data pdf.render,filename: "contrato_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline'
  end 

  def carnet 
    @contrato = Contrato.find(params[:contrato_id])
    pdf = CarnetPdf.new [@contrato]
    send_data pdf.render,filename: "carnet_nro_#{@contrato.id}", type: 'application/pdf',disposition: 'inline'
  end 

  def generar_pagos
    @contrato = Contrato.find(params[:contrato_id])
    @contrato.generar_pagos(Date.today.year)
    if(@contrato.errors.empty?)
      redirect_to @contrato, notice: "Pagos Generados del ano #{Date.today.year}"
    else
      flash[:error] = @contrato.errors.full_messages 
      redirect_to @contrato  
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
    @contrato = Contrato.find(params[:contrato_id])
  end 

  def plan
    @contrato = Contrato.find(params[:contrato_id])
    if @contrato.cambiar_plan(plan_params)
       redirect_to @contrato, notice: 'Contrato fue correctamente Actualizado.' 
    else
      render :plan_edit
    end
  end   


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contrato
      @contrato = Contrato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_params
      params.require(:contrato).permit(:cliente_id, :plan_id, :desde, :deuda, :monto, :total,:cobrador_id,:fecha_registro)
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
