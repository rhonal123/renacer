
 
json.productos @productos, partial: 'facturas/catalogo', as: :producto
json.extract! @productos, :per_page, :total_entries, :current_page 
json.recordsTotal Producto.count
json.recordsFiltered @productos.total_entries
json.draw ++@draw