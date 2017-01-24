class Plan < ApplicationRecord

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     paginate(page: page) rescue paginate(page: 1)
    else
      if(sort == "text")
        paginate(page: page).where("#nombre like ?","%#{search}%").order("#{sort} asc")
      else
         paginate(page: page).where("#{sort} like ?","%#{search}%").order("#{sort} asc")
      end 
    end 
  end     

  validates :nombre,
    presence: {message: 'Ingrese nombre '},
    length: {maximum: 120, too_long:"%{count} caracteres es el maximo  "}
  self.per_page = 12 


  def nombre_monto 
    "#{nombre.capitalize} #{monto} Bs"
  end 

end
