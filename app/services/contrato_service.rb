class ContratoService 

  attr_reader :contrato

  def initialize contrato
    @contrato = contrato
  end

  def anular
    if @contrato.valid? :anular 
      Contrato.transaction do
        @contrato.pagos.update_all estado: Pago.estados[:anulado]
        @contrato.update! monto: 0.0, total: 0.0, estado: Contrato.estados[:anulado] 
      end 
    end 
  end 

  def activar  
    @contrato.activo! if @contrato.valid? :activar     
  end 


  def inactivar  
    @contrato.inactivo! # if @contrato.valid? :activar     
  end 



  def generar_pagos_proximo_periodo
    if @contrato.valid? :pagos_proximo_periodo 
      year = Date.today.year 
      @contrato.hasta = Date.new year, 12, 31
      @contrato.desde = Date.new year,1,1 
      @contrato.generar_pagos
      @contrato.save
    end 
  end 

  def cambiar_plan plan_id
    begin
      plan = Plan.find plan_id
      if @contrato.valid? :cambiar_plan
        ano = Date.today.year
        semana = Date.today.cweek
        Contrato.transaction do 
          ano = Pago.arel_table[:ano]
          _semana = Pago.arel_table[:semana]
          estado = Pago.arel_table[:estado]
          @contrato.pagos
            .where(ano.eq(ano))
            .where(_semana.gteq(semana))
            .where(estado.eq("pendiente"))
            .update_all monto: plan.monto,plan_id: plan.id
          total = @contrato.pagos.sum :monto 
          @contrato.update! plan_id: plan.id, total: total 
        end 
      end 
    rescue ActiveRecord::RecordNotFound
      @contrato.errors.add :estado,"este plan ah sido eliminado."
    end
  end 

  def no_error?
    @contrato.errors.empty?
  end 

end 