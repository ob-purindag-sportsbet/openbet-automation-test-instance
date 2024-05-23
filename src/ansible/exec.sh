[ $ANSIBLE_EXEC_SH ] && return || ANSIBLE_EXEC_SH=1

source "${app}/src/txt.sh"
source "${app}/src/ansible/common.sh"


# Spin up EC2 instances and provision
function daws_launch() {
    run_playbook "launch" "$1"
    return $?
}


# Teardown all EC2 instances belonging to this project
function daws_teardown() {
    # Get user confirmation before trashing everything
    if [[ "${FORCE_YES}" -ne 1 ]]; then
        local project_name=$(grep 'project_name' $1 | tail -n1 | cut -d : -f 2 | awk '{$1=$1;print}');
        read -p "Do you wish to terminate all the AWS resources launched against ${project_name}? [y/n] " ans
        case "${ans}" in
            [Yy]* )
                ;;
            [Nn]* )
                console "Aborting"
                return 0
                ;;
            * )
                console "Unclear response, aborting"
                return 0
                ;;
        esac
    fi

    run_playbook "teardown" "$1"
    return $?
}
