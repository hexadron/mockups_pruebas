fs =     require 'fs'
sys =    require 'sys'
exec =   require('child_process').exec
uglify = require 'uglify-js'

String::endsWith = (str) -> @slice(-str.length) == str

puts = (str) -> sys.print "#{str}\n"

exports.minifyupdating = false

exports.sasscompile = (home) ->
	exec "compass watch", (stdout, stderr, err) ->
		if err? then puts err

exports.minify = (options) ->
	_source = options.source.trim()
	source = _source
	home (dir) ->
		source = "#{dir}/#{_source}"
		source = if source.endsWith '/' then source else "#{source}/"
		fs.readdir _source, (err, files) ->
			if err?
				puts err
			else
				# for bootstrapping
				runScript source, ->
					doTheLibsWorks "#{dir}/#{options.lib_source}", options.libs, "#{dir}/#{options.target}"
				# after bootstrap, each 600 miliseconds
				for f in files
					fs.watchFile "#{source}#{f}",
						persistent: true
						interval: 600,
						(curr, prev) ->
							if not exports.minifyupdating
								runScript source, ->
									doTheLibsWorks "#{dir}/#{options.lib_source}", options.libs, "#{dir}/#{options.target}"

doTheLibsWorks = (folder, libfiles, target) ->
	source = if folder.endsWith '/' then folder else "#{folder}/"
	files = []
	files.push "#{source}#{f.trim()}.js" for f in libfiles
	len = files.length
	i = 0
	all = ""
	f = ->
		if i < len
			fs.readFile files[i], (error, data) ->
				if not error?
					all += data
					i++
					f()
				else
					puts error
		else
			fs.readFile "/tmp/coffees.js", (error, data) ->
				if not error?
					all += data
					ast = uglify.parser.parse all
					ast = uglify.uglify.ast_mangle ast
					ast = uglify.uglify.ast_squeeze ast
					code = uglify.uglify.gen_code ast
					fs.writeFile "#{target}.js", code, (err) ->
						if err? then puts err
						exports.minifyupdating = false
				else
					puts error
	f()
														
runScript = (source, callback = -> null) ->
	exports.minifyupdating = true
	exec "coffee --join /tmp/coffees.js --compile #{source}*.coffee", ->
		callback()

home = (callback = -> null) ->
	exec "pwd", (error, stdout, stderr) ->
		callback(stdout.trim())