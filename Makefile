setup: env
	bundle install
	# ESLint для проверки JavaScript-репозиториев; без Node.js приложение работает, проверяются только Ruby-репозитории
	if command -v npm >/dev/null 2>&1; then npm install; fi
	bin/rails tailwindcss:build
	bin/rails db:prepare

env:
	test -f .env || cp .env.example .env

start:
	bin/rails server -b 0.0.0.0 -p 3000

lint:
	bundle exec rubocop
	npx -y @herb-tools/linter app/views

test:
	bin/rails test

.PHONY: setup env start lint test
