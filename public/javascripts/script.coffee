###
 Author:
###

String.prototype.contains = (chain)-> @indexOf(chain) != -1

moving = false
desplegado = undefined
clones = []

desplegar = (task) ->
	if not moving and $(task).attr('class') == '_browser'
		# clones creados todos en el mismo lugar
		for i in [1..5]
			c = (($ task).clone().css
				position: 'absolute'
				top: $(task).position().top
				left: $(task).position().left
				zIndex: 0
			).addClass('clone').appendTo('#taskbar ul')
			clones.push c
		# para luego ser lanzados en cola
		init_y = 75
		init_x = 2
		y = init_y
		x = init_x
		for c in clones
			$(c).animate
				top: "-=#{y}"
				left: "+=#{x}"
			'normal'
			x += init_x
			y += init_y
			init_x += 6
		desplegado = task
		moving = true
	else
		dieCount = 0
		for c in clones
			$(c).animate
				top: $(desplegado).position().top,
				left: $(desplegado).position().left
				'normal',
				->
					dieCount++
					if dieCount == 5
						$('.clone').remove()
						moving = false
						clones = []

$ ->
	($ '#taskbar li').bind 'click', (e) ->
		e.preventDefault()
		desplegar @

	($ '.clone').live 'dragstart click', (e)->
		time = if e.type == 'click' then 0 else 400
		fn =-> desplegar desplegado
		setTimeout fn, time