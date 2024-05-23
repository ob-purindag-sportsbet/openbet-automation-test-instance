[ $VENV_COMMON_SH ] && return || VENV_COMMON_SH=1

source "${app}/src/txt.sh"


# Checks the virtual environment is ready and activates it
# Will install the environment if it is missing
function venv_activate() {
    if [[ ! -d "${venv}" ]]; then
        err "Virtual environment missing"
        out " - running venv setup"
        source "${app}/src/venv/setup.sh"
        venv_setup
    fi

    # Check if virtualenv is initialised
    if [ ! -f "${venv}/bin/activate" ]; then
        err "Virtual environment activate binary missing. Aborting."
        exit 3
    fi

    log_n "Activating virtual environment in '${venv}'.."
    source "${venv}/bin/activate"
    local r="$?"
    log " done"
    return ${r}
}
