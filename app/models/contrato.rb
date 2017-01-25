class Contrato < ApplicationRecord

  belongs_to :cliente
  belongs_to :plan

  has_many :pagos

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
      else 
        paginate(page: page).cargar_detalle.where("#{sort} like ?","%#{search}%").order("#{sort} asc")
      end 
    end 
  end     

  def self.cargar_detalle
    eager_load(:cliente,:plan)
  end 


  def guardarContrato() 
    #Contrato.transaction do
    desdeweek = desde.cweek()
    hastaweek = hasta.cweek()
    hastaweek = 52 if(hastaweek == 1) 
    desdeweek = 1  if(desdeweek >= hastaweek)
    _deuda = 0.0 
    (desdeweek..hastaweek).each do  |n| 
     self.pagos << Pago.new({semana: n, monto: plan.monto })
       _deuda += plan.monto
    end 
    self.monto = _deuda
    self.total = _deuda
    save()
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


  def monto_pendiente
    self.pagos.where(estado: "pendiente").sum(:monto)
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
