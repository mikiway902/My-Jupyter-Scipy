# Актуальный образ с quay.io, ветка с Python 3.11
FROM quay.io/jupyter/scipy-notebook:python-3.11

# Свежий git из conda-forge (/opt/conda/bin в PATH раньше /usr/bin),
# автоформатирование (jupyterlab-code-formatter + black + isort)
# и обновление всех пакетов. Python не поднимется выше 3.11:
# он закреплён в /opt/conda/conda-meta/pinned
RUN mamba install -y -c conda-forge git \
      jupyterlab_code_formatter black isort && \
    mamba update -y --all && \
    mamba clean -afy && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Форматирование Python (isort + black) при сохранении
COPY --chown=${NB_UID}:${NB_GID} overrides.json /opt/conda/share/jupyter/lab/settings/overrides.json
