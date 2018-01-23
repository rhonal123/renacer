class Factura < ApplicationRecord
  belongs_to :cliente_fiscal, inverse_of: :facturas
  belongs_to :impuesto
  belongs_to :libro, inverse_of: :facturas,optional: true

  has_many :detalles, inverse_of: :factura, autosave: true, validate: true
  has_many :recibos, inverse_of: :factura

  accepts_nested_attributes_for :detalles 

  enum  estado: {
    pendiente: "PENDIENTE",
    cancelada: "CANCELADA",
    anulada:   "ANULADA"
  }    

  before_validation :factura_nueva, on: :create

  before_save :actualizar_cliente, on: :create


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
    Factura.where(" date_part('Y',fecha) = :ano and date_part('month',fecha) = :mes and libro_id is null ",{
      ano: ano,
      mes:mes
    })
  end 

  def self.proxima_factura
    Factura.connection.select_value("select last_value as value from facturas_id_seq") + 1
  end 

  def self.detalle 
    eager_load(:cliente_fiscal,:impuesto)
  end 

  def self.rango_de_fecha desde,hasta 
  	where(fecha..desde,fecha..hasta)
  end 

  def anulable?
    pendiente? and libro.nil?
  end 

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
  validates_with AnularFacturaValidator, on: :anular
  validates_associated :detalles
  
  self.per_page = 12 

  private

    def factura_nueva
      self.fecha = Date.today 
      self.estado = "PENDIENTE"
      self.impuesto = Impuesto.iva  if self.impuesto.nil?
      sum = self.detalles.inject(0.0) {|s,e| s + e.precio }
      self.base = sum.round(2)   
      self.monto_impuesto = (sum.round(2) * impuesto.porcentaje).round(2) unless impuesto.id == 2 
      self.total = (sum.round(2) + self.monto_impuesto).round(2)
      self.porcentaje = impuesto.porcentaje
      self.saldo = self.total 
    end 

    def actualizar_cliente
      self.cliente_fiscal.direccion = self.direccion
      self.cliente_fiscal.telefono = self.telefono
      self.cliente_fiscal.save()
    end 

end
