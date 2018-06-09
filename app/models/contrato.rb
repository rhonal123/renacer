class Contrato < ApplicationRecord

  belongs_to :cliente, inverse_of: :contratos
  belongs_to :plan, inverse_of: :contratos
  belongs_to :cobrador

  has_many :pagos, -> { eager_load(:plan).order(:id) } , dependent: :restrict_with_error , inverse_of: :contrato do 
    def por_ano ano 
      where ano: ano 
    end 

    def monto_pendiente ano=Date.today.year 
      where(estado: Pago.estados[:pendiente],ano: ano).sum(:monto)
    end 

    def total_ano ano=Date.today.year 
      where(ano: ano).sum(:monto)
    end 

    def ultimo_monto ano=Date.today.year 
      where(ano: ano).last.monto
    end 
  end 

  has_many :beneficiarios, dependent: :restrict_with_error, inverse_of: :contrato

  enum  estado: {
    creado: "CREADO",
    activo: "ACTIVO",
    anulado: "ANULADO",
    vencido: "VENCIDO"
  }    

  before_update do 
    if creado?
      Pago.where(contrato_id: id, ano: Date.today.year).delete_all
      self.hasta = Date.new Date.today.year,12,31 
      desdeweek = desde.cweek
      desdeweek = 1 if desdeweek >= 52 
      generar_pagos desdeweek 
    end 
  end 

  before_create do
    self.hasta =  Date.new Date.today.year,12,31 
    desdeweek = desde.cweek
    desdeweek = 1  if desdeweek >= 52 
    generar_pagos desdeweek 
  end

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
      paginate(page: page).cargar_detalle.order(id: :desc)
    else
      if sort == "cliente"
        paginate(page: page).
          cargar_detalle.
          where("clientes.nombres||' '||clientes.identidad  like ?","%#{search}%").order("clientes.nombres")
      elsif sort == "plan"
        paginate(page: page).cargar_detalle.where("planes.nombre like ?","%#{search}%").order("planes.nombre")
      elsif sort == "Numero"
        paginate(page: page).cargar_detalle.where("contratos.id::text like ?","%#{search.to_i}%").order("contratos.id asc")
      else 
        paginate(page: page).cargar_detalle.where("#{sort} like ?","%#{search}%").order("#{sort} asc")
      end 
    end 
  end     

  def self.cargar_detalle
    eager_load :cliente,:plan 
  end 

  validates :cliente_id, presence: {message: 'Seleccione'}
  validates :desde, presence: {message: 'Ingrese'}
  validates :plan_id, presence: {message: 'Seleccione'}
  #validate :fecha_valida? , on: [:create, :update]

  validates_with AnularContratoValidator, on: :anular
  validates_with ActivarContratoValidator, on: :activar
  validates_with CambiarPlanContratoValidator, on: :cambiar_plan
  validates_with PagosProximoPeriodoValidator, on: :pagos_proximo_periodo

  self.per_page = 12 

  def generar_pagos semana_incial= 1 
    _deuda = 0.0 
    year = self.desde.year
    (semana_incial..52).each do  |n| 
      self.pagos << Pago.new(semana: n, monto: plan.monto, plan_id: plan.id, ano: year)
     _deuda += plan.monto
    end 
    self.monto = _deuda
    self.total = _deuda
  end 
  
  private 
  #def fecha_valida?
  #  if !desde.nil? and desde.year != Date.today.year 
  #    errors.add :desde,"Error el año debe ser el año actual." 
  #  end 
  #  errors.empty?
  #end

end
