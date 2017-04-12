class Usuario < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  CAMPOS = ["Email","Nombres","Username","Estado"]

  CAMPOS_BUSQUEAD = [
    ["Email","email"],
    ["Nombres","nombres"],
    ["Username","username"],
    ["Estado","estado"]
  ]

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
      paginate(page: page).order(id: :desc) rescue paginate(page: 1).order(id: :desc) 
    elsif sort == "estado"
      search = (search.upcase == "ACTIVO" ? true : false )
      paginate(page: page).where("estado = ? ",search).order("id asc")
    else
      paginate(page: page).where("#{sort} like ?","%#{search}%").order("#{sort} asc")
    end 
  end 
  
  validates :username , 
      presence: {message: ' Ingrese un username '},
      uniqueness: {message: 'ya Registrado', on: :create },
      length: {maximum: 35 , too_long:"%{count} caracteres es el maximo  "}

  validates :email, 
         presence: {message: 'Ingrese su Email '},
         format:{ with:/.+@+[a-z]+./ , message: "Formato Invalido"}

  validates :nombres,
      presence: {message: 'Ingrese Su Nombre '},
      length: {maximum: 150, too_long:"%{count} caracteres es el maximo  "}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:authentication_keys => [:username] 
  self.per_page = 12 
end
