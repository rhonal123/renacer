class Usuario::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    redirect_to root_path
    # super
  end

  def create
    self.resource = warden.authenticate(auth_options) 
    unless self.resource.nil? 
      sign_in(resource_name,self.resource)
      respond_with resource, location: root_path
    else 
      @error = "Username o Password Invalido "
      @usuario = Usuario.new
      @usuario.username = params[:usuario][:username]
      @usuario.password = params[:usuario][:password]
      render "welcome/index"
      #redirect_to root_path
    end 
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
