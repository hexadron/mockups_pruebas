window.StartView = Backbone.View.extend

	canHide: false

	events:
		'click' : 'hide'

	initialize: ->
		me = @
		$('#start').fadeIn 'slow', ->
			me.canHide = true

	hide: ->
		if @canHide
			$('#start').fadeOut 'slow', ->
					@canHide = false