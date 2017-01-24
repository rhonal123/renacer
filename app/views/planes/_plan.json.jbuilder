json.extract! plan, :id, :nombre, :monto, :componentes, :created_at, :updated_at
json.url plan_url(plan, format: :json)