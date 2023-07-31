# Define variables
PYTHON = python3
PROJECT_NAME = StockPicker
VERSION=0.0.1
PYTHON_VERSION=3.9.6
# Define the activate and deactivate commands for Pyenv
PYENV_INSTALL = pyenv install -s $(PYTHON_VERSION)
PYENV_ACTIVATE = pyenv local $(PROJECT_NAME)
PYENV_DEACTIVATE = source deactivate $(PROJECT_NAME)
PIP_REQUIREMENTS=requirements.txt

.DEFAULT_GOAL := run

all: help

help:
	@echo "activate             - Pyenv activate."
	@echo "deactivate           - Pyenv deactivate."
	@echo "install              - Install from requirements."
	@echo "run                  - Run."
	@echo "clean                - Clean python cache."

# Activate the Pyenv virtual environment
activate:
	$(PYENV_INSTALL) && \
	if ! pyenv virtualenvs | grep -q $(PROJECT_NAME); then \
		pyenv virtualenv $(PYTHON_VERSION) $(PROJECT_NAME); \
	fi
	$(PYENV_ACTIVATE) && \
	echo "Activated Pyenv virtual environment '$(PROJECT_NAME)' with Python $(PYTHON_VERSION)"

# Deactivate the Pyenv virtual environment
# TODO: not work correctly, still shows same version when run: pyenv versions
# In order to totally delet it, need to run: make clean
deactivate:
	$(PYENV_DEACTIVATE) && \
	echo "Deactivated Pyenv virtual environment '$(PROJECT_NAME)' result with $?"

# TODO: not work: Install required packages that are not already installed
# pip install $(grep -v '^#' requirements.txt | grep -vxFf <(pip freeze) | cut -d= -f1)
# The pip install command installs the packages that are not already installed.
# grep -v '^#' requirements.txt removes any comments from requirements.txt (lines starting with #).
# grep -vxFf <(pip freeze) removes any packages that are already installed. pip freeze lists all installed packages and grep -vxFf removes any lines that match packages in the requirements.txt file.
# cut -d= -f1 removes the version information from the package names, leaving only the package names themselves.
install: activate
	pip install -r requirements.txt && \
	echo "Installed dependencies"

run: install
	$(PYTHON) main.py

clean:
	$(PYENV_DEACTIVATE) && \
	pyenv uninstall $(PROJECT_NAME) && \
	rm -rf __pycache__ && \
	rm -rf .python-version && \
	echo "Cleaned up generated files"

.PHONY: activate deactivate install run clean