class ClientesFiscalesController < ApplicationController
  before_action :set_cliente_fiscal, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /clientes_fiscales
  # GET /clientes_fiscales.json
  def index
    @clientes = ClienteFiscal.search(params[:page], params[:search], params[:sort])
  end

  # GET /clientes_fiscales/1
  # GET /clientes_fiscales/1.json
  def show
  end

  # GET /clientes_fiscales/new
  def new
    @cliente_fiscal = ClienteFiscal.new
  end

  # GET /clientes_fiscales/1/edit
  def edit
  end

  # POST /clientes_fiscales
  # POST /clientes_fiscales.json
  def create
    @cliente_fiscal = ClienteFiscal.new(cliente_fiscal_params)
    if @cliente_fiscal.save
      redirect_to @cliente_fiscal, notice: 'Cliente fiscal creado correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /clientes_fiscales/1
  # PATCH/PUT /clientes_fiscales/1.json
  def update
    if @cliente_fiscal.update(cliente_fiscal_params)
      redirect_to @cliente_fiscal, notice: 'Cliente fiscal actualizado correctamente.'
    else
      render :edit
    end
  end

  # DELETE /clientes_fiscales/1
  # DELETE /clientes_fiscales/1.json
  def destroy
    begin
      @cliente_fiscal.destroy
      redirect_to clientes_fiscales_url, notice: "#{@cliente_fiscal.nombres} fue Eliminado."
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error]  = "No Puedes Eliminar este Cliente, esta siendo utilizado."
      redirect_to clientes_fiscales_url 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente_fiscal
      @cliente_fiscal = ClienteFiscal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_fiscal_params
      params.require(:cliente_fiscal).permit(:identidad, :nombres, :direccion)
    end
end
