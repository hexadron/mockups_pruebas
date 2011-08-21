####
# Author: Hexadron
####

window.FanView = Backbone.View.extend

	deploying: false
	deployed: undefined
	clones: []

	# this data must come from a collection of models,
	# not from here.
	textos: [
		{id: '_titulo', content: '<h1>titulo</h1>'},
		{id: '_subtitulo', content: '<h2>subtitulo</h2>'},
		{id: '_parrafo', content: '<h3>parrafo</h3>'},
		{id: '_label', content: '<h4>label</h4>'}]
	formas: [
		{id: '_cuadrado', content: 'cuadrado'},
		{id: '_circulo', content: 'circulo'}]
	controles: [
		{id: '_boton', content: 'boton'},
		{id: '_radio', content: 'radio'},
		{id: '_checkbox', content: 'checkbox'}]
	cont_textos: [
		{id: '_textbox', content: 'textbox'},
		{id: '_textarea', content: 'textarea'}]
	contenedores: [
		{id: '_panel', content: 'panel'},
		{id: '_navegador', content: 'navegador'},
		{id: '_ventana', content: 'ventana'}]

	events:
		'click li:not(.clone)' : 'evalDeployment'
		'dragstart li' : 'lagRetract'
		'click .clone' : 'cloneSelect'
		'dragstart .clone' : 'lagRetract'

	initialize: () ->
		t.content = @setAsInnerClass(t.content) for t in arreglo for arreglo in [@textos, @formas, @controles, @cont_textos, @contenedores]

	evalDeployment: (e) ->
		elem = $(e.target)
		view = @
		clonefound = false
		fn = (elem)->
			if not view.deploying
				view.deploy elem
			else if elem[0] == view.deployed[0]
				view.retract()
			else
				v = @
				f = -> view.deploy elem
				view.retract f
		until clonefound
			if elem.attr('class') != undefined and elem.attr('class').split(' ')[0].startsWith '_'
					clonefound = true
			fn elem if clonefound
			elem = elem.parent()

	deploy: (item) ->
		typeclass = $(item).attr 'class'
		collection = @getArray typeclass.substring(1, typeclass.length)
		for i in collection
			c = ($ item).clone()
			c.addClass 'clone'
			c.css
				position: 'absolute'
				top: $(item).position().top
				left: $(item).position().left
				zIndex: 0
			c.appendTo '#taskbar ul'
			c.removeAttr 'id'
			c.attr 'id', i.id
			console.log "Contenido: #{i.content}"
			c.html i.content
			@clones.push c
		init_y = 65
		init_x = 0
		y = init_y
		x = init_x
		for c in @clones
			$(c).animate
				top: "-=#{y}"
				left: "+=#{x}"
			x += init_x
			y += init_y
			init_x += 5
		@deployed = item
		@deploying = true

	retract: (callback) ->
		dieCount = 1
		that = @
		for c in @clones
			myclones = @clones
			$(c).animate
				top: $(@deployed).position().top,
				left: $(@deployed).position().left
				'normal',
				->
					if dieCount == myclones.length
						$('.clone').remove()
						that.deploying = false
						that.clones = []
						callback?.call()
					dieCount++

	cloneSelect: (e)->
		that = @
		clonefound = false
		fn = (e) ->
			type = ".#{e.attr('class').split(' ')[0]}"
			id = e.attr 'id'
			content = e.html()
			$("#{type}:not(.clone)").attr('id', id).html content
			that.retract()
		elem = $(e.target)
		until clonefound
			if elem.attr('class') != undefined and elem.attr('class').contains 'clone'
					clonefound = true
			fn elem if clonefound
			elem = elem.parent()

	lagRetract: ->
		that = @
		if @deploying
			fn =-> that.retract()
			setTimeout fn, 400

	getArray: (type) ->
		switch type
			when 'text' then @textos
			when 'shape' then @formas
			when 'control' then @controles
			when 'textcontainer' then @cont_textos
			when 'container' then @contenedores

	setAsInnerClass: (str) -> "<div class='inner'>#{str}</div>"
