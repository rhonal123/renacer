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

=begin
  def totalizar_pagos(plan_id,desde,hasta)
    desde = Date.parse(desde).year 
    hasta = Date.parse(hasta).year  
    contratos.joins(:pagos).where(
      pagos: { ano: desde..hasta},
      plan_id: plan_id).
    pluck(
      Pago.arel_table[:id].count,
      Pago.arel_table[:monto].sum)
  end 
=end 
  def totalizar_pagos(plan_id,desde,hasta,estado = "pagado")
    contratos.joins(:pagos).where(
      pagos: { 
        fecha_pago: desde..hasta,
        estado: estado },
      plan_id: plan_id).
    pluck(
      Pago.arel_table[:id].count,
      Pago.arel_table[:monto].sum)
  end 

  self.per_page = 12 
end
