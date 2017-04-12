class ClientesController < ApplicationController
  before_action :set_cliente, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /clientes
  # GET /clientes.json
  def index
    @clientes = Cliente.search(params[:page], params[:search], params[:sort])
  end

  # GET /clientes/1
  # GET /clientes/1.json
  def show
  end

  # GET /clientes/new
  def new
    @cliente = Cliente.new
  end

  # GET /clientes/1/edit
  def edit
  end

  # POST /clientes
  # POST /clientes.json
  def create
    @cliente = Cliente.new(cliente_params)
    if @cliente.save
      redirect_to @cliente, notice: 'Cliente fue creado correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /clientes/1
  # PATCH/PUT /clientes/1.json
  def update
    if @cliente.update(cliente_params)
      redirect_to @cliente, notice: 'Cliente fue actualizado correctamente.'
    else
      render :edit
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.json
  def destroy
    @cliente.destroy
    if @cliente.destroyed? 
      redirect_to clientes_url, notice: "El cliente #{@cliente.nombres} fue Eliminado."
    else 
      flash[:error]  ="El cliente  #{@cliente.nombres} no puede ser elmininado posee #{@cliente.contratos.size} contratos"
      redirect_to clientes_url  
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cliente
      @cliente = Cliente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cliente_params
      params.require(:cliente).permit(:identidad, :apellidos, :nombres, :fecha, :direccion, :telefono)
    end
end

#For Rails 5, note that protect_from_forgery is no longer prepended to the before_action chain, 
#so if you have set authenticate_user before protect_from_forgery, your request will result in "Can't
# verify CSRF token authenticity." To resolve this, either change the order in which you call them,
# or use protect_from_forgery prepend: true.