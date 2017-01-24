class WelcomeController < ApplicationController
  def index
  	@usuario = Usuario.new
  end

  def cambiar_contrasena_edit
     @usuario = Usuario.new
  end

  def cambiar_contrasena 
    @usuario = current_usuario
    if @usuario.update(cambiar_contrasena_params)
      sign_in(@usuario,:bypass => true)
     	redirect_to root_path, notice: 'Contraseña cambiada.'
    else
      @usuario = Usuario.new
      @error = "los datos no son validos."
      render :cambiar_contrasena_edit   
    end
  end 

  private 
    def cambiar_contrasena_params
      params.require(:usuario).permit(:password,:password_confirmation)
    end


end
 