json.extract! cliente, :id, :identidad, :apelliso, :nombre, :fecha, :direccion, :telefono, :created_at, :updated_at
json.url cliente_url(cliente, format: :json)


json.extract! @clientes,  :size, :current_page,:total_entries
json.elements do
   json.array!(@clientes) do |cliente|
      json.extract! cliente,  :id, :identidad, :apellido, :nombre, :fecha, :direccion, :telefono
	end
end 

