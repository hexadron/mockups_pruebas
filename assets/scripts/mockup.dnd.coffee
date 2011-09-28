window.DnDView = Backbone.View.extend
	events:
		'dragstart #taskbar li, .object': 'start'
		'dragend .object': 'rm'
		'dragover #whiteboard': 'over'
		'dragleave #whiteboard': 'leave'
		'drop #whiteboard': 'drop'
		'drop .object': 'dropInElem'
	
	initialize: ->
		@inPlace = false
	
	start: (e) ->
		@inPlace = false
		opt = $(e.target)
		cad = if opt.attr('class').contains 'object'
			$('<div>').append(opt.clone()).remove().html()
		else
			opt.attr('data-content')
		e.originalEvent.dataTransfer.setData 'content', cad

	rm: (e) ->
		if @inPlace
			$(e.target).remove() 
			@inPlace = false
	
	over: (e) ->
		e.originalEvent.preventDefault()
		if $(e.target).attr('id') is 'whiteboard'
			$(e.target).css 'background-color', 'hsl(0, 0%, 90%)'
	
	leave: (e) ->
		t = $(e.target)
		t.css('background-color', 'hsl(0, 0%, 100%)') if t.attr('id') is 'whiteboard'
	
	drop: (e) ->
		if $(e.target).attr('id') is 'whiteboard' then @put e

	put: (e) ->
		@leave e
		evt = e.originalEvent
		x = evt.clientX
		y = evt.clientY
		($(evt.dataTransfer.getData 'content').css
			top: y - 20
			left: x - 20
		).addClass('object').attr('draggable', 'true').appendTo('#whiteboard')
		@inPlace = true
	
	dropInElem: (e) ->
		@put e