console.log 'i love it'

manifest = require './src/parse-appcache-manifest'
fs = require 'fs'

input = fs.readFileSync 'example2.appcache', 'utf8'
opts =
	tokenize : true
result = manifest input, opts

console.log 'result:', result
