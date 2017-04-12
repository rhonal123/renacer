class Plan < ApplicationRecord

  has_many :contratos, dependent: :restrict_with_error, inverse_of: :plan  

  has_attached_file :reporte 
  #validates_attachment :reporte, content_type: { content_type: "application/pdf" }
  validates_attachment_content_type :reporte, :content_type => ['application/pdf','application/octet-stream','binary/octet-stream']
  #do_not_validate_attachment_file_type :reporte
  #validates_attachment :reporte #, :content_type => { :content_type => 'application/force-download' }
  
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


  def update(attr)
    ano = Date.today.year
    Plan.transaction do 
      super(attr)
      Pago.joins(:contrato).where(contratos: {plan_id: self.id }, ano: ano,estado: "pendiente").update_all(monto: self.monto) if errors.empty?
      errors.empty?
    end 
  end 

  def nombre_monto 
    "#{nombre.capitalize} #{monto} Bs"
  end 

  self.per_page = 12 
end
