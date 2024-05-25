[ $VENV_SETUP_SH ] && return || VENV_SETUP_SH=1

source "${app}/src/txt.sh"
source "${app}/src/venv/common.sh"


function venv_setup() {
    log "Install venv: ${venv}"

    # Setup python virtual-env for setting up dependencies
    out_n "Checking virtualenv installation.."
    sudo -H pip3 install -qIU --no-warn-conflicts virtualenv
    is_ok

    if [[ -d "${venv}" ]]; then
        out_n "Removing previous virtual environment.."
        rm -rf "${venv}"
        is_ok
    fi

    # Create a python virtual environment
    out_n "Creating virtual environment.."
    virtualenv -q "${venv}"
    is_ok

    # Enable the virtual environment
    out_n "Activating environment.."
    venv_activate
    is_ok

    # Then install with pip3 will be inside that virtual environment
    out_n "Installing base requirements.."

    # The ignore warnings is to squelch the InsecurePlatformWarnings that happen on some versions of Python
    PYTHONWARNINGS="ignore" \
    pip3 install --upgrade -qIr "${app}/var/pip-requirements.txt"
    is_ok

    out_n "Installing Ansible plugins.."
    # Run ansible-galaxy collection install amazon.aws
    ansible-galaxy collection install -i --upgrade amazon.aws > /dev/null 2>&1

    is_ok
}
