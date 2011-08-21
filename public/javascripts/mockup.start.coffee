window.StartView = Backbone.View.extend

	canHide: false

	events:
		'click #start' : 'hide'

	initialize: ->
		me = @
		title = $('''
			<header id='start'>
				<h1>Moca</h1>
				<h4 style='font-size: .5em'>click en cualquier lado para comenzar</h4>
			</header>
		''').css
			position: 'absolute'
			top: '10%'
			width: '100%'
			height: '86%'
			display: 'none'
			fontFamily: 'Aller'
			textAlign: 'center'
			fontSize: '4.5em'
		@el.append title
		$('#start').fadeIn 'slow', ->
			me.canHide = true

	hide: ->
		console.log @canHide
		if @canHide
			$('#start').fadeOut 'slow', ->
					@canHide = false
					$('#start').remove()