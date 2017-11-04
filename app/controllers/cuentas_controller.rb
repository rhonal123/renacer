class CuentasController < ApplicationController
  before_action :set_cuenta, only: [:show, :edit, :update, :destroy,:reporte]

  # GET /cuenta
  # GET /cuenta.json
  def index
    @cuentas = Cuenta.search(params[:page], params[:search], params[:sort])
  end

  # GET /cuenta/1
  # GET /cuenta/1.json
  def show
  end

  # GET /cuenta/new
  def new
    @cuenta = Cuenta.new
  end

  # GET /cuenta/1/edit
  def edit
  end

  # POST /cuenta
  # POST /cuenta.json
  def create
    @cuenta = Cuenta.new(cuenta_params)

    respond_to do |format|
      if @cuenta.save
        format.html { redirect_to @cuenta, notice: 'Cuenta fue correctamente creado.' }
        format.json { render :show, status: :created, location: @cuenta }
      else
        format.html { render :new }
        format.json { render json: @cuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cuenta/1
  # PATCH/PUT /cuenta/1.json
  def update
    respond_to do |format|
      if @cuenta.update(cuenta_params)
        format.html { redirect_to @cuenta, notice: 'Cuenta correctamente Actualizado.' }
        format.json { render :show, status: :ok, location: @cuenta }
      else
        format.html { render :edit }
        format.json { render json: @cuenta.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuenta/1
  # DELETE /cuenta/1.json
  def destroy
    @cuenta.destroy
    respond_to do |format|
      format.html { redirect_to cuentas_url, notice: 'Cuenta fue eliminada.' }
      format.json { head :no_content }
    end
  end

  def reporte
    pdf = CuentaPdf.new @cuenta, params[:mes], params[:ano]
    send_data pdf.render,filename: "cuenta_#{@cuenta.cuenta}", type: 'application/pdf',disposition: 'inline'
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuenta
      @cuenta = Cuenta.find(params[:id] || params[:cuenta_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuenta_params
      params.require(:cuenta).permit(:cuenta, :banco_id)
    end
end
