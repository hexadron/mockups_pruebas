$ ->
	#new StartView el: $('body')
	new FanView el: $('#taskbar ul.menu')

	# prueba
	write = (text) ->
		$.ajax
			url: ''
			type: 'POST'
			async: true # if set to non-async, some browsers show: loading...
			data:
				write: true
				text: text
			timeout: 20000
			success: (res, code, xhr) ->
				if ($.trim res) is "OK"
					return false
				($ 'textarea').val res
			error: (err) ->
				console.log err
	
	read = (wait) ->
		$.ajax
			url: ''
			type: 'POST'
			async: true
			data:
				write: false
				wait: wait
			timeout: 20000
			complete: -> read true
			error: (err) -> console.log err
			success: (res) -> ($ 'textarea').val res

	($ '#send').bind 'click', ->
		text = $('textarea').val()
		write text

	read false