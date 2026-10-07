# My-Jupyter-Scipy

JupyterLab (scipy-notebook, Python 3.11) в Docker. Внутри: git, автоформатирование
при сохранении (black + isort), jupytext, LSP-автодополнение, build123d (CAD).

## Требования

Docker Desktop (запущенный).

## Первый запуск

1. Создайте файл настроек и задайте в нём свой `JUPYTER_TOKEN`:

   ```powershell
   cp .env.example .env
   ```

2. Соберите образ и запустите контейнер (первая сборка долгая, дальше быстрее за счёт кэша):

   ```powershell
   docker compose up -d --build
   ```

3. Откройте в браузере `http://127.0.0.1:8888/?token=<JUPYTER_TOKEN>`
   (порт меняется через `JUPYTER_PORT` в `.env`).

## Повседневное использование

| Действие | Команда |
| --- | --- |
| Запустить | `docker compose up -d` |
| Остановить (автозапуск сохраняется) | `docker compose stop` |
| Запустить после `stop` | `docker compose start` |
| Остановить и удалить контейнер | `docker compose down` |
| Логи | `docker compose logs` |
| Пересобрать после правок `Dockerfile` | `docker compose up -d --build` |

## Автозапуск при старте системы

В `docker-compose.yml` задано `restart: unless-stopped`, поэтому контейнер поднимается вместе с Docker Desktop.
Остаётся включить запуск самого Docker Desktop:

1. Docker Desktop → Settings → General.
2. Включить **Start Docker Desktop when you sign in to your computer** и нажать Apply.

Важно:
- Docker Desktop стартует только после входа в Windows, не раньше.
- Контейнер должен быть создан хотя бы раз через `docker compose up -d`.
- `docker compose down` удаляет контейнер, и после перезагрузки он не поднимется. Чтобы сохранить автозапуск, останавливайте через `docker compose stop`.

## Где лежат файлы

Папка `work/` монтируется в `/home/jovyan/work`: всё, что вы сохраняете в Jupyter, остаётся на диске.
Содержимое `work/` не коммитится. Настройки git (имя, email) хранятся в `work/.gitconfig`.
