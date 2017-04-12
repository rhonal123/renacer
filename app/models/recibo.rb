class Recibo < ApplicationRecord
  belongs_to :cliente_fiscal
  belongs_to :factura, inverse_of: :recibos
  has_many :pagos,class_name: "FormaPago", inverse_of: :recibo #, autosave: true, validate: true
  accepts_nested_attributes_for :pagos

  def pagos_attributes=(pagos)
    pagos.values.each do |detalle|
      pago = FormaPago.new(detalle)
      pago.fecha = Date.today if pago.fecha.nil?
      pago.estado = "ACTIVO"
      self.association(:pagos).add_to_target pago 
    end
    self.monto = self.pagos.inject(0){ |n,ele| n + (ele.monto || 0 )}
  end

  def self.crear_recibo(params,factura)
    recibo = Recibo.new(params)
    recibo.fecha = Date.today
    recibo.factura = factura
    recibo.cliente_fiscal_id = factura.cliente_fiscal_id
    recibo.estado = "ACTIVO"
    recibo.monto = recibo.pagos.inject(0){ |n,ele| n + (ele.monto || 0 )}
    Recibo.transaction do
      factura.saldo = factura.saldo - recibo.monto
      if factura.saldo <= 0
        factura.saldo = 0
        factura.estado = "CANCELADA"
      end  
      factura.save()       
      recibo.save()
    end
    recibo
  end 

  def activo?
    self.estado == "ACTIVO"
  end 

  def anulado?
    self.estado == "ANULADO"
  end 

  def anular
    Recibo.transaction do
      self.factura.saldo = self.factura.saldo + self.monto
      if self.factura.saldo > self.factura.total 
        self.factura.saldo = self.factura.total
      end 
      self.estado = "ANULADO"
      self.monto = 0.0
      self.factura.save()       
      self.save()
      self.pagos.update_all(monto: 0,estado: "ANULADO" )
    end
  end 

  validates :fecha,     presence: {message: 'Ingrese Fecha'}
  validates :cliente_fiscal, presence: {message: 'Ingrese Cliente Fiscal'}
  validates :monto,     presence: {message: 'Ingrese Monto'}
  validates :factura,     presence: {message: 'Ingrese Factura'}
  validates :estado,    presence: {message: 'Ingrese Estado'}
  validates :concepto, length: {maximum: 300, too_long:"%{count} caracteres es el maximo  "}

  validates_associated :pagos
  self.per_page = 12 
end
