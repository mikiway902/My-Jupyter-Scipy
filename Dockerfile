# Актуальный образ с quay.io, ветка с Python 3.11
FROM quay.io/jupyter/scipy-notebook:python-3.11

# Свежий git из conda-forge (/opt/conda/bin в PATH раньше /usr/bin),
# автоформатирование (jupyterlab-code-formatter + black + isort),
# jupytext, LSP (автодополнение), время выполнения ячеек.
# `mamba update --all` убран: базовый образ и так свежий, а полный
# пересчёт и перекачка всех пакетов занимали основную часть сборки.
# Кэш пакетов вынесен в cache mount (uid/gid = jovyan): при пересборке
# уже скачанное не качается заново и не попадает в слой образа.
RUN --mount=type=cache,target=/opt/conda/pkgs,uid=1000,gid=100 \
    mamba install -y -c conda-forge git \
      jupyterlab_code_formatter black isort \
      jupytext jupyterlab-lsp python-lsp-server jupyterlab_execute_time \
      jupyterlab-git

# Панель PyPI Manager отключена: её поиск расширений не работает
# (PyPI закрыл поисковый API), а поставленное из интерфейса пропадает
# при пересоздании контейнера. Расширения добавляем здесь, в Dockerfile.
RUN jupyter labextension disable @jupyterlab/extensionmanager-extension

# CAD: build123d (ядро OpenCascade в колёсах cadquery-ocp, они тяжёлые).
# Через pip: на conda-forge заметно устаревшая версия
RUN --mount=type=cache,target=/tmp/pip-cache,uid=1000,gid=100 \
    pip install --cache-dir /tmp/pip-cache build123d

# fix-permissions один раз в конце: на каждый вызов по /opt/conda
# приходится копирование всех затронутых файлов в новый слой
RUN fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Форматирование Python (isort + black) при сохранении
COPY --chown=${NB_UID}:${NB_GID} overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json
