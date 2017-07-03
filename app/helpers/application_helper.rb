module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type.to_s
      when "success"
        "alert-success" # Green
      when "error"
        "alert-danger" # Red
      when "alert"
        "alert-warning" # Yellow
      when "notice"
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

  def detalle(campo,texto,ancho = nil)
    ancho = "col-md-4" if ancho.nil?
    content_tag :div , class: ancho do 
      content_tag :blockquote  do 
        content_tag :p do 
          content_tag(:strong,campo.to_s.capitalize) + 
          texto.to_s
        end 
      end  
    end 
  end  
  
  def titulo(text ,text2="")
    content_tag :div, class: "page-header2" do 
      content_tag :h4 do
        ["#{text} ",content_tag(:small,text2)].join.html_safe
      end 
    end 
  end 

  def index_titulo
    titulo(controller.controller_name.humanize.capitalize)    
  end 

  def nuevo_titulo
    titulo(controller.controller_name.humanize.capitalize,"Nuevo")    
  end 

  def editar_titulo
    titulo(controller.controller_name.humanize.capitalize,"Editar")    
  end 

  def active(nombre)
    "active" if (nombre.is_a? String and nombre == action_name) or (nombre.is_a? Array and nombre.include?(action_name))
  end 

  def buscar(url,columnas,classform = "",elements=[])
    form_tag url,remote: false, class: "navbar-form navbar-right #{classform} buscar",method: 'get',role: "search",
      style: 'margin: 0px'  do     
      content_tag :div , class: "form-group form-group-sm " do |div|
        array = [] 
        array = array + elements 
        array << text_field_tag(:search, params[:search], class:"form-control", style:"width:inherid",placeholder: "Buscar")  
        array << select_tag(:sort ,options_for_select(columnas,params[:sort]), class: "form-control",style: "width:100px;")
        array << submit_tag("Buscar",class: 'btn btn-default btn-sm', :name => nil)  
        array.join.html_safe
      end 
    end 
  end 


  def buscar_rango_fecha(url,columnas,classform = "",elements=[])
    form_tag url,remote: false,
      id: "form_buscar",
      class: "navbar-form navbar-right #{classform} buscar",
      method: 'get',
      role: "search",
      style: 'margin: 0px'  do     
      content_tag :div , class: "form-group form-group-sm " do |div|
        array = [] 
        array = array + elements 
        array << text_field_tag(:desde, params[:desde], class:"form-control",style:"width:inherid",placeholder: "Desde")  
        array << text_field_tag(:hasta, params[:hasta], class:"form-control",style:"width:inherid",placeholder: "Hasta")  
        array << text_field_tag(:search, params[:search], class:"form-control", style:"width:inherid",placeholder: "Buscar")  
        array << select_tag(:sort ,options_for_select(columnas,params[:sort]), class: "form-control",style: "width:100px;")
        array << submit_tag("Buscar",class: 'btn btn-default btn-sm', :name => nil)  
        array.join.html_safe
      end 
    end 
  end 


  def tabla_panel_responsive(titulos,contenido,parametros={})
    tbody = "table-#{controller_name}" if parametros[:tbody].nil? 
    partial = parametros[:partial] 
    style = parametros[:style]
    content_tag :div, class: "panel panel-default table-responsive", style: "min-height: 70%; height: 480px" do
      content_tag :table, class: "table table-hover", style: "text-align: center;"  do 
        contenido = content_tag(
          :tbody, 
          render(collection:contenido, partial: partial,locals: { parametros: parametros }),id:"#{tbody}")
          [table_head(titulos),contenido].join.html_safe 
        end 
      end 
  end 


  def table_head(titulos,colspan="1")
    width = 95 / titulos.size;  
    colspan = content_tag(:th,"",colspan: colspan, style: "width: 5%;")    
    content_tag :thead do 
      content_tag :tr, class: "btn-primary" do 
        contenido = []
        titulos.each  do |title| 
          if title.instance_of?(Hash)
            contenido.append(content_tag(:th,title[:title], style: "text-align: center; width: #{title[:width]};")) 
          else 
            contenido.append(content_tag(:th,title, style: "text-align: center; width: #{width}%;"))
          end 
        end 
        contenido.append(colspan)
        contenido.join.html_safe 
      end 
    end 
  end 


  def paginador(lista,parametros =  {} )
    clase = parametros[:clase]
    clase ||= "paginador"
    content_tag :div, class: "botonera" do 
      content_tag(:div,will_paginate(lista,renderer: BootstrapPagination::Rails, class: clase , params: parametros) ) +
      content_tag(:p,page_entries_info(lista,parametros)) 
    end 
  end 

  def nav_link(text, path=nil,controlador =nil,parametros={})
      options = controller.controller_name ==controlador ? { class: "active" } : {}
      parametros[:class] = "menu_principal" if parametros[:class].nil?
      #parametros[:remote]= true
      content_tag(:li, options) do
          link_to text, path , parametros
      end
  end

	def content_menu symbol,options ={}, &block
		options[:class] = (options[:class].nil? ? "content-menu" : options[:class] << " content-menu")
		content_tag(symbol,capture(&block),options) # if block_given?
	end 

	def content_accion symbol,options ={}, &block
		options[:class] = (options[:class].nil? ? "content-accion" : options[:class] << " content-accion")
		content_tag symbol,capture(&block),options
	end 

  def nav_bar parametros = {}
    elementos = []
    parametros[:class] = "nav nav-pills nav-stacked #{parametros[:class]}"
      yield(elementos)
    content_tag(:ul, parametros ) do  
        elementos.join.html_safe
    end
  end

  def content_li_a title,params={},params_li={}
    content_li content_boton_a(title,params),params_li      
  end 

  def content_li element , params = {}
    content_tag :li, element ,params 
  end 


  def contenedor_row  &block
       content_tag :div,capture(&block),class: "row"
  end 

  def content_boton_a(element,params={})
    url = params[:url]
    params = params.merge(class: "btn btn-default") if params[:class].nil?
    params = params.merge(remote: true ) if params[:remote].nil?
    if url.nil?
      content_tag :a,element, params.merge(href: "#")  
    else 
      link_to element, url, params 
    end 
  end 


  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: 'card card-danger') do
        concat(content_tag(:div, class: 'card-header') do
          concat(content_tag(:h4, class: 'card-title') do
            concat "El formulario posee #{pluralize(object.errors.count, 'errore')}"
          end)
        end)
        concat(content_tag(:div, class: 'card-block') do
          concat(content_tag(:ul) do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end

  def moneda_venezuela(monto)
    number_to_currency(monto,unit: "Bs", format: "%n %u")
  end 


  def moneda(monto)
    number_to_currency(monto,unit: "", format: "%n %u")
  end 

end
