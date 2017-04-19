class Cobrador < ApplicationRecord

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
 
  self.per_page = 12 
end
