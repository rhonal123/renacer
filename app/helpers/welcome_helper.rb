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
    if  usuario_signed_in? 
      nav_bar class: "menu" do |nav|
        nav.append(nav_link("Renacer",root_path,"renacer"))
        clientes = sub_menu "Clientes" do |e|
          e.append(nav_link("Clientes",clientes_path,"clientes"))
          e.append(nav_link("Clientes Fiscales",clientes_fiscales_path,"clientes_fiscales"))
        end 
        nav.append clientes 
        nav.append(nav_link("Planes",planes_path,"planes"))
        #nav.append(nav_link("Contratos",contratos_path,"contratos"))

        contratos = sub_menu "Contratos" do |e|
          e.append nav_link("CREADOS",creados_contratos_path,"creados") 
          e.append nav_link("ACTIVOS",activos_contratos_path,"activos") 
          e.append nav_link("INACTIVOS",inactivos_contratos_path,"inactivo")
          e.append nav_link("ANULADOS",anulados_contratos_path,"anulado")
          e.append nav_link("HISTORICO",contratos_path,"historico") 
        end 
        nav.append contratos
        nav.append(nav_link("Cobradores",cobradores_path,"cobradores"))
        nav.append(nav_link("Prodcutos",productos_path,"productos"))
        facturacion = sub_menu "Facturacion" do |e|
          e.append nav_link("Facturas",facturas_path,"facturas") 
          e.append nav_link("Libro ventas",libros_path,"libros")
          e.append nav_link("Impuestos",impuestos_path,"impuestos") 
          e.append nav_link("Cuentas Bancarias",cuentas_path,"cuentas") 
        end 
        nav.append facturacion 
        nav.append(nav_link("Cuentas por Cobrar", cuenta_por_cobrar_index_path ,"cuenta_por_cobrar"))
        nav.append(nav_link("Configuracion",configuracion_path,"configuracion"))
      end 
    end 
  end 

  def has_form_error(object,key)
    object.errors.has_key?(key) ? "form-group form-group-sm  has-error": " form-group form-group-sm " 
  end 

  def element &block
    capture(&block)
  end 



end
