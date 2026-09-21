# My-Jupyter-Scipy

JupyterLab (scipy-notebook, Python 3.11) в Docker.

## Запуск

1. `cp .env.example .env` и задайте свой `JUPYTER_TOKEN`
2. `docker compose up -d --build`
3. Открыть http://127.0.0.1:8888/?token=<JUPYTER_TOKEN>

Папка `work/` монтируется в `/home/jovyan/work` (содержимое не коммитится).
Остановка: `docker compose down`.
