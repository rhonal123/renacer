Rails.application.routes.draw do


  root 'welcome#index'
  get  'cambiar_contrasena' => 'welcome#cambiar_contrasena_edit'
  post 'cambiar_contrasena' => 'welcome#cambiar_contrasena'

  resources :libros, only: [:new,:create,:index,:destroy,:show] do 
    get  "imprimir", action: "imprimir"
  end 
  
  resources :clientes_fiscales
  resources :productos
  resources :clientes

  resources :cuenta_por_cobrar, only: [:index,:show] do 
    get "estado", action: "estado"
  end 

  resources :contratos do 
    get   "catulina"       ,action: "catulina",       as: :catulina
    get   "contrato"       ,action: "contrato",       as: :contrato
    get   "carnet"         ,action: "carnet",         as: :carnet
    get   "cobrador"       ,action: "cobrador_edit" 
    post  "cobrador"       ,action: "cobrador" 
    get   "pagos"          ,action: "pagos"             ,as: :pagos ,defaults: { format: :js }, constraints: { :format => '(js)' }  
    get   "pagos_cobrados" ,action: "pagos_cobrados", on: :collection
    post  "generar_pagos"  ,action: "generar_pagos",  as: :generar_pagos 
    patch "pagar/:pago_id" ,action: "pagar",          as: :pagar
    patch "activar"        ,action: "activar",        as: :activar
   
    get "fecha_registro"   ,action: "fecha_registro_edit" ,as: :fecha_registro
    post "fecha_registro"   ,action: "fecha_registro"

    get "propietario"   ,action: "propietario_edit" ,as: :propietario
    post "propietario"   ,action: "propietario"


    resources :beneficiarios, only: [:new,:create,:edit,:update,:destroy],defaults: { format: :js }, constraints: { :format => '(js)' }  
  end 

  resources :facturas, only: [:show,:new,:create,:index] do 
    get "productos", action: "productos", on: :collection ,defaults: { format: :json }, constraints: { :format => '(json)' }  
    post "agregar", action: "agregar", on: :collection  ,defaults: { format: :js }, constraints: { :format => '(js)' }  
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
