module WelcomeHelper


	def informacion_usuario
		botonname = content_tag(:button,"Usuario : #{current_usuario.nombres} ", class: "btn btn-default")
		caret = content_tag(:span,"",class: "caret")

		boton =  content_tag :button,data:{ toggle: "dropdown"}, class: "btn btn-default dropdown-toggle", type: "button" do 
			 caret
		end  
		ul = content_tag :ul , class: "dropdown-menu" do 
 			content_tag(:li,link_to("Cambiar Contraseña",  cambiar_contrasena_path)) +
 			content_tag(:li,"",role: "separator", class: "divider")   + 
 			content_tag(:li,link_to("Cerrar Session", destroy_usuario_session_path ,method: "delete", data: { confirm: "Quieres Cerar Session ?"} ))  
		end 
		content_tag :div , class: "navbar-right" do 
			content_tag :div, class: "btn-group" , style: " padding-top: 10px;" do 
			  botonname+boton + ul 
			end 
		end 
	end  

 	def detalle_usuario
 		usuario = current_usuario 
	  div = content_tag :div, class: "row"  do
	    detalle("username:",usuario.username)
	    detalle("Nombres:",usuario.nombres) + 
	    detalle("email:",usuario.email) + 
	    detalle("estado:", usuario.estado ? "Activo": "INACTIVO" )  
	  end 
	  content_tag :div do 
    	content_tag(:h4,"Datos Usuario ", class: "page-header2") + 
    	div 
	  end 
 	end 





  def sub_menu(title)
    content_tag :li,class: "dropdown-submenu" do
      elementos = []
      a = content_tag(:a,title,{"class" => "dropdown-toggle", "data-toggle" => "dropdown", "href" => "#", "role" => "button", "aria-haspopup" => "true", "aria-expanded" => "false" })
      submenu = content_tag(:ul,{class: "dropdown-menu  multi-level"}) do 
        elementosSub = []
        yield(elementosSub)
        elementosSub.join.html_safe
      end 
        elementos.append a
      elementos.append submenu
      elementos.join.html_safe
    end
  end 


  def menu 
    #if  usuario_signed_in? 
      nav_bar class: "menu" do |nav|
        nav.append(nav_link("Renacer",root_path,"renacer"))
        nav.append(nav_link("Clientes",clientes_path,"clientes"))
        nav.append(nav_link("Planes",planes_path,"planes"))
        nav.append(nav_link("Contratos",contratos_path,"contratos"))
      end 
    #end 
  end 




end
