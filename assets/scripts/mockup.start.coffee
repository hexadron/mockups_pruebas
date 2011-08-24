window.StartView = Backbone.View.extend

	canHide: false

	events:
		'click' : 'hide'

	initialize: ->
		$('#start').fadeIn 'slow', =>
			@canHide = true

	hide: ->
		if @canHide
			$('#start').fadeOut 'slow', ->
					@canHide = false