class BeneficiariosController < ApplicationController
  before_action :set_beneficiario, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /beneficiarios/new
  def new
    @beneficiario = Beneficiario.new({contrato_id: params[:contrato_id]})
  end

  # GET /beneficiarios/1/edit
  def edit
  end

  # POST /beneficiarios
  # POST /beneficiarios.json
  def create
    @beneficiario = Beneficiario.new(beneficiario_params)
    if @beneficiario.save()
      render :create
    else
      render :new 
    end
  end

  # PATCH/PUT /beneficiarios/1
  # PATCH/PUT /beneficiarios/1.json
  def update
    if @beneficiario.update(beneficiario_params)
      render :update
    else
      render :edit
    end
  end

  # DELETE /beneficiarios/1
  # DELETE /beneficiarios/1.json
  def destroy
    @beneficiario.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beneficiario
      @beneficiario = Beneficiario.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beneficiario_params
      params.require(:beneficiario).permit(:contrato_id,:identidad, :apellidos, :nombres, :fechaNacimiento, :parentesco )
    end
end
 