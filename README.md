# Анализатор качества репозиториев

[![hexlet-check](https://github.com/kicha3007-boop/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kicha3007-boop/rails-project-66/actions)
[![CI](https://github.com/kicha3007-boop/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/kicha3007-boop/rails-project-66/actions/workflows/ci.yml)

Сервис запускает проверки кода в репозиториях GitHub и показывает отчёт о состоянии кодовой базы. Аналог [qlty.sh](https://qlty.sh/).

Учебный проект Хекслета: https://ru.hexlet.io/programs/rails

## Возможности

- Вход через GitHub (OmniAuth), токен пользователя сохраняется для запросов к API
- Добавление своих репозиториев с GitHub (Octokit); поддерживаются Ruby и JavaScript (enumerize)
- Проверка в фоне (ActiveJob): клонирование свежей версии и запуск линтера — Rubocop для Ruby, ESLint для JavaScript. Конфиги линтеров лежат в приложении (`config/linters`), а не в проверяемом репозитории
- Этапы проверки описаны конечным автоматом (AASM): создана → выполняется → завершена / не удалась
- Вебхук `POST /api/checks` устанавливается при добавлении репозитория и запускает проверку после каждого push
- Письмо владельцу, если проверка не пройдена
- Внешние зависимости (клиент GitHub, git, запуск линтеров) собраны в контейнере `dry-container`; в тестах они подменяются заглушками

## Установка и запуск

```bash
git clone https://github.com/kicha3007-boop/rails-project-66.git
cd rails-project-66
make setup   # .env из .env.example, гемы, ESLint (npm), Tailwind, база
make start   # http://localhost:3000
```

В `.env` укажите `GITHUB_CLIENT_ID` и `GITHUB_CLIENT_SECRET` OAuth-приложения GitHub (callback: `http://localhost:3000/auth/github/callback`) и `BASE_URL` — внешний адрес сервиса для вебхуков (например, адрес туннеля ngrok).

## Разработка

```bash
make test    # тесты
make lint    # rubocop и herb-lint (нужен Node.js для npx)
```

## Деплой

Продакшен ожидает переменные окружения `DATABASE_URL` (PostgreSQL), `SECRET_KEY_BASE`, `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`, `BASE_URL` и, по желанию, `SENTRY_DSN` для отправки ошибок в Bugsink.

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>
