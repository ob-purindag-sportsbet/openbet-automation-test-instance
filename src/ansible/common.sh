[ $ANSIBLE_COMMON_SH ] && return || ANSIBLE_COMMON_SH=1

source "${app}/src/txt.sh"
source "${app}/src/venv/common.sh"

# Executes an Ansible playbook
function run_playbook() {
    local playbook="${venv}/bin/ansible-playbook"

    log "Run play: $1"
    log "Playbook: ${playbook}"
    log "Project: $2"

    local target=$(grep 'target' $2 | tail -n1 | cut -d : -f 2 | awk '{$1=$1;print}');

    # Play "teardown" should not be run for local target
    if [[ "$1" == "teardown" ]]; then
        if [[ "${target}" == "local" ]]; then
            err "Teardown not supported for local target"
            return 1
        fi
    fi

    # Based on the `target` variable in the developer-machine.yml file, we can determine if targetting AWS or local
    if [[ "${target}" == "aws" ]]; then
        local profile=$(grep 'aws_profile' $2 | tail -n1 | cut -d : -f 2 | awk '{$1=$1;print}');
        log "Target: AWS using ${profile} profile"
    else
        local profile="localhost profile"
        log "Target: Local"
        ask_sudo_pw="--ask-become-pass"
    fi

    venv_activate

    # Run the playbook
    if [[ -x "${playbook}" ]]; then
        # Ansible doesn't allow passing the arguments to the dynamic_inventory script used in the ${playbook} command
        # hence we need to export the variables here and refer to them in the dynamic_inventory script.
        export INVENTORY_YAML_FILE=$2

        ANSIBLE_CONFIG="${app}/ansible/ansible.cfg" \
        ANSIBLE_FORCE_COLOR=true \
        AWS_PROFILE="${profile}" \
        ${playbook} -i "${app}/ansible/inventory/dynamic_inventory.py" ${ask_sudo_pw} --extra-vars="@$2" $(get_verbose_arg) "${app}/ansible/$1.yml" 2>&1 | tee -a "${log}"
        return $?
    else
        err "Ansible Playbook binary is missing or not executable"
        return 1
    fi
}

# Get the appropriate CLI argument for Ansible's verbosity
function get_verbose_arg() {
    if [[ "${VERBOSE}" -eq 1 ]]; then
        printf -- -v
    fi
}