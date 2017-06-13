class Libro < ApplicationRecord
	has_many :facturas, inverse_of: :libro, autosave: true , dependent: :nullify

  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     detalle.paginate(page: page) rescue paginate(page: 1)
    else
      detalle.paginate(page: page).where("#{sort} like ?","%#{search}%").order("#{sort} asc")
    end 
  end  

	def self.crear_libro(mes,ano)
		facturas = Factura.facturas(mes,ano)
		libro = Libro.new(
			mes: mes,
			ano: ano,
			base: facturas.inject(0) {|s,fac| s + fac.base },
			total: facturas.inject(0) {|s,fac| s + fac.total },
		)
		facturas.each { |f| libro.facturas << f }
		libro
	end 

	validates :mes,      presence: {message: 'Ingrese el Mes.'}
	validates :ano,      presence: {message: 'Ingrese el  Año.'}
	validates :base,     presence: {message: 'Ingrese Base.'}
	validates :total,    presence: {message: 'Ingrese Total.'}
	#validates :declarado,presence: {message: 'esta declarado?.'}

	validate :validar_fechas_libro, on: :create
 	
	def puede_eliminar?
		errors.add(:declarado,"No pudes eliminar este libro se enuentra declarado") if declarado?
		raise "No Puedes eliminar este Libreo se encuentra declarado " unless errors.blank?
	end 

	before_destroy do
	  puede_eliminar?
	  #throw(:abort) if errors.present?
	end

	def validar_fechas_libro
		if Libro.where(ano: self.ano, mes: self.mes).exists?
			self.errors.add(:mes,"EL Libro de este mes ya ah sido generado.")
		end 
		fecha = Date.today 
		if(self.ano > fecha.year)
			self.errors.add(:ano, "No Puedes Generar el libro de este ano #{self.ano}")
		else
			if(self.mes > fecha.month and self.ano == fecha.year)
				self.errors.add(:mes, "No Puedes Generar el libro de este mes #{self.ano}")
			end 
		end 		
	end 
end
