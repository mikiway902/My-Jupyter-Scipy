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

## Как добавить расширение JupyterLab

Менеджер расширений в интерфейсе отключён: поиск через PyPI не работает, а всё, что поставлено из интерфейса, пропадает при пересоздании контейнера. Расширения добавляются в `Dockerfile`.

1. Найдите пакет на https://conda-forge.org (предпочтительно) или https://pypi.org. Обычно он называется `jupyterlab-...` или `jupyterlab_...`.
2. Добавьте имя в первый `RUN` с `mamba install` в `Dockerfile`.
   Если пакета нет на conda-forge, добавьте его во второй `RUN`: `pip install --cache-dir /tmp/pip-cache build123d <новый-пакет>`.
3. Пересоберите и перезапустите:

   ```powershell
   docker compose up -d --build
   ```

4. Обновите страницу JupyterLab. Проверить, что расширение подхвачено:

   ```powershell
   docker compose exec jupyter jupyter labextension list
   ```

Расширению может понадобиться своя настройка (например, форматирование при сохранении настроено в `overrides.json`).
Уже установлены: jupyterlab-git, jupyterlab-lsp, jupyterlab_code_formatter, jupytext, jupyterlab_execute_time.

## Где лежат файлы

Папка `work/` монтируется в `/home/jovyan/work`: всё, что вы сохраняете в Jupyter, остаётся на диске.
Содержимое `work/` не коммитится. Настройки git (имя, email) хранятся в `work/.gitconfig`.
