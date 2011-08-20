# ###
#  Author: Hexadron
# ###

window.FanView = Backbone.View.extend

	deploying: false
	deployed: undefined
	clones: []

	# this data must comes from a collection of models,
	# not from here.
	browsers: [
		{id: '_safari', content: 'safari'},
		{id: '_chrome', content: 'chrome'}, 
		{id: '_firefox', content: 'firefox'},
		{id: '_opera', content: 'opera'},
		{id: '_ie9', content: 'ie9'}]
	windows: [
		{id: '_macosx', content: 'macosx'},
		{id: '_windows', content: 'windows'},
		{id: '_unity', content: 'unity'},
		{id: '_gnome', content: 'gnome'}]
	smarts: [
		{id: '_ios', content: 'ios'},
		{id: '_android', content: 'android'},
		{id: '_winphone', content: 'winphone'},
		{id: '_symbian', content: 'symbian'}]
	textelements: [
		{id: '_textbox', content: 'textbox'},
		{id: '_textarea', content: 'textarea'},
		{id: '_passfield', content: 'passfield'}]
	buttons: [
		{id: '_normal', content: 'normal'},
		{id: '_multi', content: 'multi'},
		{id: '_radio', content: 'radio'},
		{id: '_icon', content: 'icon'}]

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
			'normal'
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
						if !(callback is undefined)
							callback.call()
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
			when 'browser' then @browsers
			when 'window' then @windows
			when 'smartphone' then @smarts
			when 'text' then @textelements
			when 'button' then @buttons

$ -> new FanView el: $('#taskbar')
