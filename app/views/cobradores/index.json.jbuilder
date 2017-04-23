 

json.extract! @cobradores,  :size, :current_page,:total_entries
json.elements do
   json.array!(@cobradores) do |cobrador|
      json.extract! cobrador,  :id, :identidad, :nombre
	end
end 

