json.extract! libro, :id, :mes, :ano, :base, :total, :declarado, :created_at, :updated_at
json.url libro_url(libro, format: :json)