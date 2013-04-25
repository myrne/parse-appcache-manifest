build:
	mkdir -p lib
	rm -rf lib/*
	node_modules/.bin/coffee --compile -m --output lib/ src/

watch:
	node_modules/.bin/coffee --watch --compile --output lib/ src/
	
test:
	node_modules/.bin/mocha

jumpstart:
	curl -u 'meryn' https://api.github.com/user/repos -d '{"name":"parse-appcache-manifest", "description":"Parses HTML5 application cache manifest","private":false}'
	mkdir -p src
	touch src/parse-appcache-manifest.coffee
	mkdir -p test
	touch test/parse-appcache-manifest.coffee
	npm install
	git init
	git remote add origin git@github.com:meryn/parse-appcache-manifest
	git add .
	git commit -m "jumpstart commit."
	git push -u origin master

.PHONY: test