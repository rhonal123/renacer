class LibrosController < ApplicationController
  before_action :set_libro, only: [:show, :edit, :update, :destroy]
  include LibrosHelper

  # GET /libros
  # GET /libros.json
  def index
    @libros = Libro.search(params[:page], params[:search], params[:sort])
  end

  # GET /libros/1
  # GET /libros/1.json
  def show
  end

  # GET /libros/new
  def new
    if(params[:mes].nil? and params[:ano].nil?)
      mes = Date.today.month
      ano = Date.today.year
    else
      mes = params[:mes]
      ano = params[:ano]
    end 
    @libro = Libro.crear_libro(mes,ano)
  end

  # POST /libros
  # POST /libros.json
  def create
    parametros = libro_params
    @libro = Libro.crear_libro(parametros[:mes],parametros[:ano])
    @libro.declarado = parametros[:declarado]
    if @libro.save
      redirect_to @libro, notice: 'Libro fue creado correctamente.'
    else
      render :new
    end
  end

  # DELETE /libros/1
  # DELETE /libros/1.json
  def destroy
    begin
     @libro.destroy
     redirect_to libros_url, notice: "El Libro del mes #{@libro.mes} #{@libro.ano} fue Eliminado."
    rescue Exception => e
      flash[:error]  ="El Libro #{meses_libro(@libro.mes)} -- #{@libro.ano} no puede ser elmininado."
      redirect_to libros_url  
    end
  end


  def imprimir
    @libro = Libro.find(params[:libro_id])
    pdf = LibroPdf.new @libro
    send_data pdf.render,filename: "Libro_#{@libro.id}", type: 'application/pdf',disposition: 'inline'
  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_libro
      @libro = Libro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def libro_params
      params.require(:libro).permit(:mes, :ano,:declarado)
    end
end
