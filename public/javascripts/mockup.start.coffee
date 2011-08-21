window.StartView = Backbone.View.extend

	canHide: false

	events:
		'click #start' : 'hide'

	initialize: ->
		me = @
		title = $('''
			<header id='start'>
				<h1 style='margin-top: 10%;'>moca</h1>
				<h4 style='font-size: .5em; margin-top: -1.5em'>click en cualquier lado para comenzar a crear una interfaz</h4>
			</header>
		''').css
			position: 'absolute'
			top: '0'
			width: '100%'
			height: '100%'
			display: 'none'
			color: 'hsl(0, 0%, 0%)'
			fontFamily: 'Comfortaa'
			fontWeight: 'bold'
			textAlign: 'center'
			fontSize: '4.5em'
			textShadow: '0 0 20px hsl(0, 0%, 60%)'
			backgroundColor: 'hsla(0, 0%, 0%, 0.1)'
		@el.append title
		$('#start').fadeIn 'slow', ->
			me.canHide = true

	hide: ->
		console.log @canHide
		if @canHide
			$('#start').fadeOut 'slow', ->
					@canHide = false
					$('#start').remove()