json.extract! @clientes,  :size, :current_page,:total_entries
json.elements do
   json.array!(@clientes) do |cliente|
      json.extract! cliente,  :id, :identidad, :apellidos, :nombres, :fecha, :direccion, :telefono
	end
end 

