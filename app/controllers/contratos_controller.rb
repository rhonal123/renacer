class ContratosController < ApplicationController
  before_action :set_contrato, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

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
    respond_to do |format|
      if @contrato.guardarContrato
        format.html { redirect_to @contrato, notice: 'Contrato was successfully created.' }
        format.json { render :show, status: :created, location: @contrato }
      else
        format.html { render :new }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contratos/1
  # PATCH/PUT /contratos/1.json
  def update
    respond_to do |format|
      if @contrato.update(contrato_params)
        format.html { redirect_to @contrato, notice: 'Contrato was successfully updated.' }
        format.json { render :show, status: :ok, location: @contrato }
      else
        format.html { render :edit }
        format.json { render json: @contrato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contratos/1
  # DELETE /contratos/1.json
  def destroy
    @contrato.anular()
    respond_to do |format|
      format.html { redirect_to contratos_url, notice: 'Contrato was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def pagar 
    @contrato = Contrato.find(params[:contrato_id])
    @contrato.pagar(params[:pago_id])
    respond_to do |format|
      format.html { redirect_to @contrato, notice: 'Contrato Actualizado' }
    end 
  end 



  def activar 
    @contrato = Contrato.find(params[:contrato_id])
    @contrato.activar()
    respond_to do |format|
      if @contrato.estado == "ACTIVO"
        format.html { redirect_to @contrato, notice: 'Contrato Activado' }
      else 
        format.html { redirect_to @contrato, notice: 'Error al activar el contrato' }
      end 
    end 
  end 



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contrato
      @contrato = Contrato.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contrato_params
      params.require(:contrato).permit(:cliente_id, :plan_id, :desde, :hasta, :deuda, :monto, :total)
    end
end
