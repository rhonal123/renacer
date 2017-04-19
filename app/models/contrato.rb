class Contrato < ApplicationRecord

  belongs_to :cliente, inverse_of: :contratos
  belongs_to :plan, inverse_of: :contratos

  has_many :pagos, dependent: :restrict_with_error , inverse_of: :contrato

  has_many :beneficiarios, dependent: :restrict_with_error, inverse_of: :contrato

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
    eager_load(:cliente,:plan)
  end 

=begin
  al generar un contrato guardare el ano actual y luego genero los pagos del ano 
  actual, si se apertura un nuevo año se genera los pagos de todo el año 
=end 
  def guardar_contrato() 
    #Contrato.transaction do
    desdeweek = desde.cweek()
    hastaweek = hasta.cweek()
    hastaweek = 52 if(hastaweek == 1) 
    desdeweek = 1  if(desdeweek >= hastaweek)
    _deuda = 0.0 
    (desdeweek..hastaweek).each do  |n| 
     self.pagos << Pago.new({semana: n, monto: plan.monto, ano: desde.year })
      _deuda += plan.monto
    end 
    self.monto = _deuda
    self.total = _deuda
    save()
    errors.empty?
  end 

  def generar_pagos(ano)
    if(ano != self.desde.year)
      self.desde = Date.new(ano,1,1)
      self.hasta = Date.new(ano,12,31)
      _deuda = 0.0 
      (1..52).each do  |n| 
        self.pagos << Pago.new({semana: n, monto: plan.monto, ano: ano })
        _deuda += plan.monto
      end 
      self.monto = _deuda
      self.total = _deuda
      save()
    else
      errors.add(:estado,"NO puedes generar pago de este año, dado que es el año entransito del contrato.")
    end 
    errors.empty?
  end 


  # CREADO -> ACTIVO -> ANULADO -> VENCIDO
  def anular() 
    if self.estado != "CREADO"
      self.errors.add(:estado, "No Puedes Anular este Contrato. se encuenta #{self.estado}")
    else 
      Contrato.transaction do
        self.monto = 0.0
        self.total = 0.0
        self.estado = "ANULADO"
        self.pagos.update_all(estado: "anulado")
        save!()
      end 
    end 
    errors.empty?
  end 


  # CREADO -> ACTIVO -> ANULADO -> VENCIDO
  def cambiar_plan(plan_params) 
    plan = Plan.find(plan_params[:plan_id])
    unless ["CREADO","ACTIVO"].include?(self.estado) 
      self.errors.add(:estado, "No Puedes Cambiar el Plan,este Contrato. se encuenta #{self.estado}")
    else 
      ano = Date.today.year()
      semana = Date.today.cweek()
      Contrato.transaction do
        self.plan = plan 
        ano = Pago.arel_table[:ano]
        _semana =  Pago.arel_table[:semana]
        estado =  Pago.arel_table[:estado]
        self.pagos
          .where(ano.eq(ano))
          .where(_semana.gteq(semana))
          .where(estado.eq("pendiente"))
          .update_all(monto: plan.monto)
        self.total = self.pagos.sum(:monto)
        save!()
      end 
    end 
    errors.empty?
  end 


  def activar() 
    if self.estado != "CREADO"
      self.errors.add(:estado, "No Puedes Activar este Contrato. se encuenta #{self.estado}")
    else 
      Contrato.transaction do
        self.estado = "ACTIVO"
        save!()
      end 
    end 
    errors.empty?
  end 

  def pagar(pago_id)
    if self.estado == "ACTIVO"
      Contrato.transaction do
        pendiente = 0.0 
        pagos.each do |pago|
          if(pago.id == pago_id.to_i)
            pago.estado = "pagado"
            pago.fecha_pago = Date.today 
            pago.save()
          else 
            pendiente += pago.monto if(pago.estado == "pendiente")        
          end 
        end
        self.monto = pendiente
        self.update({monto: pendiente})
      end 
    end 
  end 

  def anulado?
    self.estado == "ANULADO"
  end  

  def no_anulado?
    !anulado?
  end 

  def activo?
    self.estado == "ACTIVO"
  end 

  def inactivo?
    !activo?
  end 

  def monto_pendiente ano=Date.today.year
    self.pagos.where(estado: "pendiente",ano: ano).sum(:monto)
  end 

  def total_ano  ano=Date.today.year 
    self.pagos.where(ano: ano).sum(:monto)
  end 

  def ultimo_monto(ano=Date.today.year)
    self.pagos.where(ano: ano).last.monto
  end 

  validates :cliente_id, 
      presence: {message: 'Seleccione'}

  validates :desde, 
      presence: {message: 'Ingrese'}

  validates :hasta, 
      presence: {message: 'Ingrese'}

  validates :plan_id, 
      presence: {message: 'Seleccione'}

  validate :fechas_validas? 

  def fechas_validas?
    if !desde.nil?  and !hasta.nil? and desde >= hasta 
      errors.add(:desde,"Desde debe ser menor a Hasta.")
    end 
    errors.empty?
  end

  self.per_page = 12 
end
