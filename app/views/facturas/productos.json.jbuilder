
 
json.productos @productos, partial: 'facturas/catalogo', as: :producto
json.extract! @productos, :per_page, :total_entries, :current_page 
