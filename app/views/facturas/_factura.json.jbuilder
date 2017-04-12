json.extract! factura, :id, :fecha, :tipo, :estado, :base, :total, :saldo, :observacion, :clienteFiscal_id, :direccion, :created_at, :updated_at
json.url factura_url(factura, format: :json)