class Impuesto < ApplicationRecord

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     paginate(page: page) rescue paginate(page: 1)
    else
      if(sort == "text")
        paginate(page: page).where(" descripcion like ?","%#{search}%").order("id asc")
      end 
    end 
  end     

	def self.iva id 
		find(id || 1 )
	end 



  validates :descripcion, 
      presence: {message: 'Ingrese Descripción'},
      uniqueness: {message: 'Descripción Registrada', on: :create }

    validates :porcentaje,
      presence: {message: 'Ingrese.'} ,
      uniqueness: {message: 'Porcentaje Registrado', on: :create },
      numericality: { greater_than_or_equal_to: 0 , less_than_or_equal_to: 1  }

  self.per_page = 12 

end
