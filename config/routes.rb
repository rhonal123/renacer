Rails.application.routes.draw do


  resources :cuentas do 
    get :reporte
  end 

  get  'configuracion' => 'welcome#configuracion_edit'
  post 'configuracion' => 'welcome#configuracion'

  resources :cobradores do
    get "planilla/liquidacion", action: "planilla_liquidacion", as: :planilla_liquidacion 
    get :pagar
    get  "pagar/seleccionar/:idcontrato", action: "seleccionar_contrato", as: :seleccionar_contrato
    patch "pagar/:pago_id" ,action: "pagar_pago", as: :pagar_pago
  end 

  root 'welcome#index'
  get  'cambiar_contrasena' => 'welcome#cambiar_contrasena_edit'
  post 'cambiar_contrasena' => 'welcome#cambiar_contrasena'

  resources :libros, only: [:new,:create,:index,:destroy,:show] do 
    get  "imprimir", action: "imprimir"
  end 
  
  resources :clientes_fiscales
  resources :productos
  resources :clientes
  resources :impuestos
  resources :cuenta_por_cobrar, only: [:index,:show] do 
    get "estado", action: "estado"
  end 

  resources :contratos do 
    get   "catulina"       ,action: "catulina",       as: :catulina

    get   "activos/all"       ,action: "activos",       as: :activos, on: :collection
    get   "inactivos/all"       ,action: "inactivos",       as: :inactivos, on: :collection
    get   "creados/all"       ,action: "creados",       as: :creados, on: :collection
    get   "anulados/all"       ,action: "anulados",       as: :anulados, on: :collection

    

    get   "contrato"       ,action: "contrato",       as: :contrato
    get   "carnet"         ,action: "carnet",         as: :carnet
    get   "cobrador"       ,action: "cobrador_edit" 
    post  "cobrador"       ,action: "cobrador" 
    get   "pagos"          ,action: "pagos"             ,as: :pagos ,defaults: { format: :js }, constraints: { :format => '(js)' }  
    get   "pagos_cobrados" ,action: "pagos_cobrados", on: :collection
    post  "generar_pagos"  ,action: "generar_pagos",  as: :generar_pagos 
    patch "pagar/:pago_id" ,action: "pagar",          as: :pagar
    patch "activar"        ,action: "activar",        as: :activar
    patch "inactivar"      ,action: "inactivar",        as: :inactivar
   
    get "fecha_registro"   ,action: "fecha_registro_edit" ,as: :fecha_registro
    post "fecha_registro"   ,action: "fecha_registro"

    get "propietario"   ,action: "propietario_edit" ,as: :propietario
    post "propietario"   ,action: "propietario"

    get "plan"   ,action: "plan_edit" ,as: :plan
    post "plan"   ,action: "plan"

    resources :beneficiarios, only: [:new,:create,:edit,:update,:destroy],defaults: { format: :js }, constraints: { :format => '(js)' }  
  end 

  resources :facturas, only: [:show,:new,:create,:index] do 
    get "productos", action: "productos", on: :collection ,defaults: { format: :json }, constraints: { :format => '(json)' }  
    #post "agregar", action: "agregar", on: :collection  ,defaults: { format: :js }, constraints: { :format => '(js)' }  
    delete "anular", action: "anular"
    get  "imprimir", action: "imprimir"
    resources :recibos, only: [:new,:create,:show] do 
      delete "anular", action: "anular"
      get  "imprimir", action: "imprimir"
      post "agregar", action: "agregar", on: :collection  ,defaults: { format: :js }, constraints: { :format => '(js)' }  
    end 
  end

  resources :planes do 
    patch    "reporte", action: "reporte", as: :reporte
    get    "reporte", action: "reporte_edit" 
  end 

  devise_for :usuarios,path: '', only: [:sessions,:passwords], controllers: {
    sessions: 'usuario/sessions',
    passwords: 'usuario/passwords'
  }

end
