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
        log "Target: "
    fi

    venv_activate

    # Run the playbook
    if [[ -x "${playbook}" ]]; then
        ANSIBLE_CONFIG="${app}/ansible/ansible.cfg" \
        ANSIBLE_FORCE_COLOR=true \
        AWS_PROFILE="${profile}" \
        ${playbook} -i "${app}/ansible/inventory/dynamic_inventory.py $2" "${app}/ansible/$1.yml" --extra-vars="@$2" $(get_verbose_arg) 2>&1 | tee -a "${log}"
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