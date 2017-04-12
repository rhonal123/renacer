class View::CuentaPorCobrar < ApplicationRecord

  has_many :facturas,-> { where(estado: "PENDIENTE") }, foreign_key: "cliente_fiscal_id" 
  self.table_name =  "view_cuentas_por_cobrar"
  self.primary_key = "id"
  
  def self.search(page = 1 , search , sort)
    search ||= ""
    sort ||= "" 
    if search.empty? 
     paginate(page: page) rescue paginate(page: 1)
    else
      paginate(page: page).where(" nombres||' '||identidad like ?","%#{search}%").order("identidad asc")
    end 
  end     

  def readonly?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH VIEW view_cuentas_por_cobrar')
  end
  self.per_page = 12 
end
