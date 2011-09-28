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
		{id: '_parrafo', content: '<p>Lorem Ipsum Lalala</p>'},
		{id: '_label', content: '<h4>label</h4>'}]
	formas: [
		{id: '_cuadrado', content: "<div class='square'></div>"},
		{id: '_circulo', content: "<div class='circle'></div>"}]
	controles: [
		{id: '_boton', content: 'boton'},
		{id: '_radio', content: 'radio'},
		{id: '_checkbox', content: 'checkbox'}]
	cont_textos: [
		{id: '_textbox', content: 'textbox'},
		{id: '_textarea', content: 'textarea'}]
	contenedores: [
		{id: '_panel', content: 'panel'},
		{id: '_navegador', content: "<div class='navigator'></div>"},
		{id: '_ventana', content: 'ventana'}]

	events:
		'click li:not(.clone)' : 'evalDeployment'
		'dragstart li' : 'lagRetract'
		# 'click .clone:not(._item)' : 'cloneSelect'
		'dragstart .clone' : 'lagRetract'

	initialize: () ->
		t.content = @setAsInnerClass(t.content) for t in arreglo for arreglo in [@textos, @formas, @controles, @cont_textos, @contenedores]
		@clones = {}

	evalDeployment: (e) ->
		elem = $(e.target)
		clonefound = false
		fn = (elem) =>
			if not @deploying and elem.hasClass('.clone') is false
				@deploy elem
			else if elem[0] == @deployed[0]
				@retract (->), elem
			else if elem.hasClass "_item"
				f = => @deploy elem
				@retract f, elem
		until clonefound
			if elem.attr('class')? and elem.attr('class').startsWith '_'
				clonefound = true
			fn elem if clonefound
			elem = elem.parent()

	deploy: (item) ->
		typeclass = $(item).attr('class').split(' ')[0]
		
		unless $(item).hasClass('_item')
			@clones[typeclass] = []
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
				c.attr 'data-content', i.content
				@clones[typeclass].push c
				$(item).addClass '_item'

		init_y = 65
		init_x = 0
		y = init_y
		x = init_x

		for c in @clones[typeclass]
			$(c).animate
				top: "-#{y}"
				left: "+=#{x}"
			x += init_x
			y += init_y
			init_x += 5
		
		@deployed = item
		@deploying = true

	retract: (callback, elem) ->
		dieCount = 1
		type = elem.attr('class').split(' ')[0]
		that = @
		for c in @clones[type]
			myclones = @clones[type]
			$(c).animate
				top: $(@deployed).position().top,
				left: $(@deployed).position().left
				'normal',
				=>
					if dieCount == myclones.length
						that.deploying = false
						@clones[type][@clones[type].length - 1].addClass '_item'
						callback?.call()
					dieCount++

	cloneSelect: (e)->
		clonefound = false
		fn = (e) =>
			type = "#{e.attr('class').split(' ')[0]}"
			id = e.attr 'id'
			content = e.html()
			$(".#{type}:not(.clone)").attr('id', id).html content
			@retract((->), e)
			# $(".#{type}._item").removeClass '_item'
			# e.addClass('_item').css 'z-index', '10'
		elem = $(e.target)
		until clonefound
			if elem.attr('class')? and elem.attr('class').contains 'clone'
					clonefound = true
			fn elem if clonefound
			elem = elem.parent()

	lagRetract: ->
		that = @
		if @deploying
			fn =-> that.retract((->), that.deployed)
			setTimeout fn, 400

	getArray: (type) ->
		switch type
			when 'text' then @textos
			when 'shape' then @formas
			when 'control' then @controles
			when 'textcontainer' then @cont_textos
			when 'container' then @contenedores

	setAsInnerClass: (str) -> "<div class='inner'>#{str}</div>"
