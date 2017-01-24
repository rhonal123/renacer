json.extract! @planes,  :size, :current_page,:total_entries
json.elements do
   json.array!(@planes) do |plan|
      json.extract! plan,  :id, :nombre, :monto, :componentes
	end
end 

