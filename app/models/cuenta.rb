class Cuenta < ApplicationRecord

  belongs_to :banco
  has_many :forma_pagos, dependent: :restrict_with_error, inverse_of: :cuenta

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

  self.per_page = 12 

  def monto_acumuado mes, ano 
    inicio = Date.new ano, mes, 1 
    fin = inicio.end_of_month
    forma_pagos.where(created_at: inicio..fin).sum(:monto)
  end 


  validates :cuenta, 
      presence: {message: 'Ingrese Numero de cuenta'},
      uniqueness: {message: 'Numero de cuenta Registrado ', on: :create },
      length: {maximum: 35, too_long:"%{count} caracteres es el maximo  "}
  
  validates :banco,
      presence: {message: 'Ingrese.'}
  
 


end
