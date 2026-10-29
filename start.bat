@echo off
rem JupyterLab without Docker: local .venv with the same packages as the Dockerfile
cd /d "%~dp0"

if not exist ".venv\Scripts\jupyter-lab.exe" (
    py -3.12 -m venv .venv || (echo Python 3.12 not found: install it from python.org & pause & exit /b 1)
    .venv\Scripts\python -m pip install --upgrade pip
    .venv\Scripts\pip install jupyterlab numpy scipy pandas matplotlib seaborn sympy openpyxl ^
        jupyterlab-code-formatter black isort jupytext jupyterlab-lsp python-lsp-server ^
        jupyterlab-execute-time jupyterlab-git || (echo Package install failed & pause & exit /b 1)
    rem extension manager search is broken (PyPI closed its search API), same as in Docker
    .venv\Scripts\jupyter labextension disable --level=sys_prefix @jupyterlab/extensionmanager-extension
)

rem format on save (isort + black); copied every start so edits to overrides.json apply
if not exist ".venv\share\jupyter\lab\settings" mkdir ".venv\share\jupyter\lab\settings"
copy /y overrides.json ".venv\share\jupyter\lab\settings\overrides.json" >nul

.venv\Scripts\jupyter-lab --ServerApp.root_dir="%~dp0work"
pause
