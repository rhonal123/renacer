class Cobrador < ApplicationRecord
  has_many :contratos
  has_many :pagos 

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     paginate(page: page) rescue paginate(page: 1)
    else
      if(sort == "text")
        paginate(page: page).where(" nombres||' '||identidad like ?","%#{search}%").order("identidad asc")
      else
        paginate(page: page).where("#{sort} like ?","%#{search}%").order("#{sort} asc")
      end 
    end 
  end     

 
  validates :identidad, 
      presence: {message: 'Ingrese Rif ó cedula de identidad '},
      uniqueness: {message: 'Identidad Registrada ', on: :create },
      length: {maximum: 16 , too_long:"%{count} caracteres es el maximo"}
    
  validates :nombre,
    presence: {message: 'Ingrese.'},
    length: {maximum: 180, too_long:"%{count} caracteres es el maximo"}

  def totalizar_pagos(plan_id,desde,hasta,estado = "pagado")
    self.pagos.
    where(
      estado: estado,
      plan_id: plan_id).
    where("fecha_pago >= ? and fecha_pago <= ?",desde,hasta).
    pluck(
      Pago.arel_table[:id].count,
      Pago.arel_table[:monto].sum
    )
  end 

  def pendiente_por_cobrar(plan_id)
    contratos.joins(:pagos).where(
      pagos: { 
        fecha_pago: nil,
        estado: "pendiente"
      },
      plan_id: plan_id
    ).sum("pagos.monto")
  end 

  self.per_page = 12 
end
