class ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /productos
  # GET /productos.json
  def index
    @productos =  Producto.search(params[:page], params[:search], params[:sort])
  end

  # GET /productos/1
  # GET /productos/1.json
  def show
  end

  # GET /productos/new
  def new
    @producto = Producto.new
  end

  # GET /productos/1/edit
  def edit
  end

  # POST /productos
  # POST /productos.json
  def create
    @producto = Producto.new(producto_params)
    if @producto.save
      redirect_to @producto, notice: 'Producto fue creado correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /productos/1
  # PATCH/PUT /productos/1.json
  def update
    if @producto.update(producto_params)
      redirect_to @producto, notice: 'Producto fue actualizado correctamente.'
    else
      render :edit
    end
  end

  # DELETE /productos/1
  # DELETE /productos/1.json
  def destroy
    begin
      @producto.destroy
      redirect_to productos_url, notice: "Producto #{@producto.descripcion} fue Eliminado."
    rescue ActiveRecord::InvalidForeignKey => e
      flash[:error]  = "No Puedes Eliminar este Producto, esta siendo utilizado."
      redirect_to productos_url 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producto
      @producto = Producto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def producto_params
      params.require(:producto).permit(:descripcion, :precio)
    end
end
