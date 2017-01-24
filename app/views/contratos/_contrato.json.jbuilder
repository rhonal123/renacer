json.extract! contrato, :id, :cliente_id, :plan_id, :desde, :hasta, :deuda, :monto, :total, :created_at, :updated_at
json.url contrato_url(contrato, format: :json)