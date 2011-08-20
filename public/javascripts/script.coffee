# ###
#  Author: Hexadron
# ###

window.FanView = Backbone.View.extend

	deploying: false
	deployed: undefined
	clones: []

	# this data must come from a collection of models,
	# not from here.
	textos: [
		{id: '_titulo', content: 'titulo'},
		{id: '_subtitulo', content: 'subtitulo'},
		{id: '_parrafo', content: 'parrafo'},
		{id: '_label', content: 'label'}]
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

	evalDeployment: (e) ->
		that = $(e.target)
		if not @deploying
			@deploy that
		else if that[0] == @deployed[0]
			@retract()
		else
			view = @
			fn = -> view.deploy that
			@retract fn

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
			c.attr 'id', "_#{i.id}"
			c.html i.content
			@clones.push c
		init_y = 72
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
		type = ".#{$(e.target).attr('class').split(' ')[0]}"
		id = $(e.target).attr 'id'
		content = $(e.target).html()
		$(type).attr('id', id).html content
		@retract()

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

$ -> new FanView el: $('#taskbar')
