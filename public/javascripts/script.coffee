# ###
#  Author:
# ###

window.FanView = Backbone.View.extend
	events:
		'click li' : 'evalDeployment'
		'dragstart li' : 'listLagDeploy'
		'click .clone' : 'cloneLagDeploy'
		'dragstart .clone' : 'listLagDeploy'

	#global variables
	deploying: false
	deployed: undefined
	clones: []
	#global arrays
	browsers = ['S', 'C', 'F', 'I', 'O']

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
		for i in [1..5]
			c = ($ item).clone()
			c.addClass 'clone'
			c.css
				position: 'absolute'
				top: $(item).position().top
				left: $(item).position().left
				zIndex: 0
			c.appendTo '#taskbar ul'
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
			$(c).animate
				top: $(@deployed).position().top,
				left: $(@deployed).position().left
				'normal',
				->
					if dieCount == 5
						$('.clone').remove()
						that.deploying = false
						that.clones = []
						if !(callback is undefined)
							callback.call()
					dieCount++

	listLagDeploy: -> @lagDeploy 400

	cloneLagDeploy: -> @lagDeploy 0

	lagDeploy: (time)->
		that = @
		if @deploying
			fn =-> that.retract()
			setTimeout fn, time

$ -> new FanView el: $('#taskbar')
