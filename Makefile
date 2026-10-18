setup:
	bundle install
	bin/rails tailwindcss:build
	bin/rails db:prepare

start:
	bin/rails server -b 0.0.0.0 -p 3000

.PHONY: setup start
