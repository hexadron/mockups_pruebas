# ###
#  Author: Hexadron
# ###

window.FanView = Backbone.View.extend

	deploying: false
	deployed: undefined
	clones: []

	browsers: ['safari', 'chrome', 'firefox', 'ie9', 'opera']
	windows: ['macosx', 'windows', 'unity', 'gnome']
	smarts: ['ios', 'android', 'winphone', 'symbian']
	textelements: ['textbox', 'textarea', 'passfield']
	buttons: ['normal', 'multi', 'radio', 'icon']

	events:
		'click li:not(.clone)' : 'evalDeployment'
		'dragstart li' : 'listLagDeploy'
		'click .clone' : 'cloneSelect'
		'dragstart .clone' : 'listLagDeploy'

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
		collection = @getArray $(item).attr 'class'
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
			c.attr 'id', "_#{i}"
			c.html i
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

	listLagDeploy: -> @lagDeploy 400

	cloneSelect: (e)->
		@lagDeploy 0
		type = ".#{$(e.target).attr('class').split(' ')[0]}"
		id = $(e.target).attr 'id'
		name = id.substring 1, id.length
		console.log "#{type} #{id} #{name}"
		$(type).attr('id', id).html name


	lagDeploy: (time) ->
		that = @
		if @deploying
			fn =-> that.retract()
			setTimeout fn, time

	getArray: (type) ->
		switch "#{type.substring(1, type.length)}s"
			when 'browsers' then @browsers
			when 'windows' then @windows
			when 'smartphones' then @smarts
			when 'texts' then @textelements
			when 'buttons' then @buttons

$ -> new FanView el: $('#taskbar')
