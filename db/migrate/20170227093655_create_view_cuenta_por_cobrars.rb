class CreateViewCuentaPorCobrars < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL
   		CREATE OR REPLACE VIEW view_cuentas_por_cobrar AS
			select cf.id as id ,identidad, nombres, sum(f.saldo) as porcobrar from clientes_fiscales cf 
			inner join facturas f on f.cliente_fiscal_id = cf.id  
			where f.estado = 'PENDIENTE'
			group by cf.id,identidad, nombres 
    SQL
  end
end
 
