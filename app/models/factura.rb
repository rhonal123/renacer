class Factura < ApplicationRecord
  belongs_to :cliente_fiscal, inverse_of: :facturas
  belongs_to :impuesto
  belongs_to :libro, inverse_of: :facturas,optional: true

  has_many :detalles, inverse_of: :factura, autosave: true, validate: true
  has_many :recibos, inverse_of: :factura

  accepts_nested_attributes_for :detalles 

  #accepts_nested_attributes_for :detalles #, :reject_if => lambda { |a| puts("--->",a) } 
  #before_validation :remove_whitespaces
  def detalles_attributes=(detalles)
    detalles.values.each do |detalle|
      d = Detalle.new(detalle)
      d.precio = d.producto.precio * d.cantidad 
      d.precio_unitario = d.producto.precio 
      self.association(:detalles).add_to_target d 
    end
  end

  def self.search(page = 1 , search , sort,desde,hasta)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     detalle.desde_hasta(desde,hasta).paginate(page: page).order(id: :desc)
    else
      if(sort == "cliente")
        detalle.
          desde_hasta(desde,hasta).
          paginate(page: page).
          where(" nombres||' '||identidad like ?","%#{search}%").
          order("identidad asc")
      else
        detalle.
          desde_hasta(desde,hasta).
          paginate(page: page).
          where("#{sort} like ?","%#{search}%").
          order("#{sort} asc")
      end 
    end 
  end  

  def self.desde_hasta(desde,hasta)
    if desde.nil? and hasta.nil?
      all 
    else
      if desde.nil? 
        where("fecha <= ?",hasta)
      elsif hasta.nil?
        where("fecha >= ?",desde)
      else
        where(fecha: desde..hasta)
      end 
    end 
  end 

  def self.facturas(mes,ano)
    Factura.where("date_part('Y',fecha) = :ano and date_part('month',fecha) = :mes and libro_id is null ",{
      ano: ano,
      mes:mes
      })
  end 

  def self.detalle 
    eager_load(:cliente_fiscal,:impuesto)
  end 

  def self.rango_de_fecha desde,hasta 
  	where(fecha..desde,fecha..hasta)
  end 

  def self.factura_nueva(params)
    factura = new(params)
    factura.fecha = Date.today 
    factura.estado = "PENDIENTE"
    factura.calcular_montos
    return factura 
  end 

  def calcular_montos 
    sum = self.detalles.inject(0.0) {|s,e| s + e.precio }
    self.base = sum.round(2)   
    self.total = (sum.round(2) + sum.round(2) * impuesto.porcentaje).round(2)
    self.monto_impuesto = (sum.round(2) * impuesto.porcentaje).round(2) if impuesto.id == 1 
    self.porcentaje = impuesto.porcentaje
    self.saldo = self.total 
  end 

  def agregar(producto)
    sum = 0.0
    self.detalles.each do |detalle|
      sum += detalle.precio
      if detalle.producto_id == producto.id 
        return 
      end 
    end 
    self.base = sum     
    self.total = sum + sum * impuesto.porcentaje
    self.saldo = self.total 
    self.monto_impuesto = (sum.round(2) * impuesto.porcentaje).round(2)
    self.porcentaje = impuesto.porcentaje
    detalles << Detalle.new( producto: producto, 
        cantidad: 0.0,
        precio_unitario: producto.precio,
        precio: 0.0 )
  end 


  def anular()
    if self.estado == "PENDIENTE" and self.libro.nil?
      self.estado = "ANULADA"
      self.base   = 0
      self.total  = 0
      self.saldo  = 0
      self.monto_impuesto = 0
      self.porcentaje = 0
      save()
    else
      self.errors.add(:estado,"No Puedes Anular esta Factura se encuenta #{self.estado}") if self.estado != "PENDIENTE"
      self.errors.add(:estado,"No Puedes Anular esta Factura pertenece al libro del mes #{self.libro.mes}") unless self.libro.nil?
    end 
    return self.errors.empty?
  end 

  def pendiente?
    self.estado == "PENDIENTE"
  end 

  def cancelada?
    self.estado == "CANCELADA"
  end 

  def anulada?
    self.estado == "ANULADA"
  end 

  def anulable?
    pendiente? and libro.nil?
  end 

  validates :base,      
    presence: { message: 'Ingrese Base.' }
  
  validates :total,
    presence: { message: 'Ingrese Total.'}
  
  validates :saldo,
    presence: { message: 'Ingrese Saldo'}
  
  validates :direccion,
   presence: { message: 'Ingrese Estado'}

  validates :estado,
    presence: { message: 'Ingrese Estado'}

  validates :tipo,
    presence: { message: 'Ingrese Tipo'}

  validates :fecha,
    presence: { message: 'Ingrese Fecha'}

  validates :cliente_fiscal,
    presence: { message: 'Ingrese Cliente Fiscal'}

  validates :detalles,
    presence: { message: 'Ingrese Productos'}

  validates :direccion,
      length: { maximum: 400, too_long:"%{count} caracteres es el maximo"}

  validates :telefono,
      length: { maximum: 35, too_long:"%{count} caracteres es el maximo"}


  validates_associated :detalles
  self.per_page = 12 

end
