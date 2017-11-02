class ImpuestosController < ApplicationController
  before_action :set_impuesto, only: [:show, :edit, :update, :destroy]

  # GET /impuestos
  # GET /impuestos.json
  def index
    @impuestos = Impuesto.search(params[:page], params[:search], params[:sort])
  end

  # GET /impuestos/1
  # GET /impuestos/1.json
  def show
  end

  # GET /impuestos/new
  def new
    @impuesto = Impuesto.new
  end

  # GET /impuestos/1/edit
  def edit
  end

  # POST /impuestos
  # POST /impuestos.json
  def create
    @impuesto = Impuesto.new(impuesto_params)

    respond_to do |format|
      if @impuesto.save
        format.html { redirect_to @impuesto, notice: 'Impuesto was successfully created.' }
        format.json { render :show, status: :created, location: @impuesto }
      else
        format.html { render :new }
        format.json { render json: @impuesto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /impuestos/1
  # PATCH/PUT /impuestos/1.json
  def update
    respond_to do |format|
      if @impuesto.update(impuesto_params)
        format.html { redirect_to @impuesto, notice: 'Impuesto was successfully updated.' }
        format.json { render :show, status: :ok, location: @impuesto }
      else
        format.html { render :edit }
        format.json { render json: @impuesto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impuestos/1
  # DELETE /impuestos/1.json
  def destroy
    @impuesto.destroy
    respond_to do |format|
      format.html { redirect_to impuestos_url, notice: 'Impuesto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_impuesto
      @impuesto = Impuesto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def impuesto_params
      params.require(:impuesto).permit(:descripcion,:porcentaje)
    end
end
