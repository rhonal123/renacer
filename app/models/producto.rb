class Producto < ApplicationRecord

  def self.search_factura(start=0,length=10, search , sort)
    search ||= ""
    sort ||= "" 
    page = (start.to_i / length.to_i) +1
    if search.empty? 
      paginate(page: page,per_page: length) rescue paginate(page: 1)
    else
      paginate(page: page,per_page: length).where("descripcion like ?","%#{search}%").order("descripcion asc")
    end 
  end   


  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
      paginate(page: page) rescue paginate(page: 1)
    else
      paginate(page: page).where("descripcion like ?","%#{search}%").order("descripcion asc")
    end 
  end  

  validates :descripcion,
    presence: {message: 'Ingrese Descripcion '},
    length: {maximum: 120, too_long:"%{count} caracteres es el maximo  "}

  self.per_page = 12 
end
