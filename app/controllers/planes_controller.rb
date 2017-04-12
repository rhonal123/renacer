class PlanesController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_usuario!

  # GET /planes
  # GET /planes.json
  def index
    @planes = Plan.search(params[:page], params[:search], params[:sort])
  end

  # GET /planes/1
  # GET /planes/1.json
  def show
  end

  # GET /planes/new
  def new
    @plan = Plan.new
  end

  # GET /planes/1/edit
  def edit
  end

  # POST /planes
  # POST /planes.json
  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to @plan, notice: 'Plan fue creado correctamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /planes/1
  # PATCH/PUT /planes/1.json
  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: 'Plan fue actualizado correctamente.'
    else
      render :edit
    end
  end

  # DELETE /planes/1
  # DELETE /planes/1.json
  def destroy
    @plan.destroy
    if @plan.destroyed? 
      redirect_to planes_url, notice: "El plan #{@plan.nombre} fue Eliminado."
    else 
      flash[:error]  ="El plan  #{@plan.nombre} no puede ser elmininado posee #{@plan.contratos.size} contratos."
      redirect_to planes_url  
    end 
  end

  def reporte
    @plan = Plan.find(params[:plan_id])
    if @plan.update(plan_reporte_params)
      redirect_to @plan, notice: 'Reporte actualizado correctamente.'
    else
      render :reporte_edit
    end
  end 

  def reporte_edit
    @plan = Plan.find(params[:plan_id])
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:nombre, :monto, :componentes,:convenio)
    end

    def plan_reporte_params
      params.require(:plan).permit(:reporte)
    end

end
