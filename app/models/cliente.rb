class Cliente < ApplicationRecord
  has_many :contratos, dependent: :restrict_with_error, inverse_of: :cliente

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

  def nombre_corto
    _nombre = self.nombres.split()[0]
    _apellido = self.apellidos.split()[0]
    "#{_nombre} #{_apellido} #{self.identidad}"
  end 


  def nombre_completo
    "#{self.nombres} #{self.identidad}"
  end 
 
  def direcion_corta
    "#{self.direccion[0..130]}"
  end 

  validates :identidad, 
      presence: {message: 'Ingrese Rif ó cedula de identidad '},
      uniqueness: {message: 'Identidad Registrada ', on: :create },
      length: {maximum: 16 , too_long:"%{count} caracteres es el maximo  "}
    
    validates :nombres,
      presence: {message: 'Ingrese.'},
      length: {maximum: 180, too_long:"%{count} caracteres es el maximo  "}

    validates :apellidos,
      length: {maximum: 120, too_long:"%{count} caracteres es el maximo  "}

    validates :direccion,
      length: {maximum: 400, too_long:"%{count} caracteres es el maximo  "}

    validates :telefono,
      length: {maximum: 80, too_long:"%{count} caracteres es el maximo  "}

  self.per_page = 12 

end
