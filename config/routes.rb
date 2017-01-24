Rails.application.routes.draw do


  root 'welcome#index'
  get  'cambiar_contrasena' => 'welcome#cambiar_contrasena_edit'
  post 'cambiar_contrasena' => 'welcome#cambiar_contrasena'


  #   get 'products/:id' => 'catalog#view'


   
  resources :contratos do 
    patch  "pagar/:pago_id", action: "pagar", as: :pagar
    patch  "activar", action: "activar", as: :activar
  end 


 



  resources :planes
  resources :clientes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :usuarios,path: '', only: [:sessions,:passwords], controllers: {
    sessions: 'usuario/sessions',
    passwords: 'usuario/passwords'
  }

end
