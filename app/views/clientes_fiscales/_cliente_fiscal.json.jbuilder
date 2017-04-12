json.extract! cliente_fiscal, :id, :identidad, :nombres, :direccion,:telefono, :created_at, :updated_at
json.url cliente_fiscal_url(cliente_fiscal, format: :json)