[ $ANSIBLE_EXEC_SH ] && return || ANSIBLE_EXEC_SH=1

source "${app}/src/txt.sh"
source "${app}/src/ansible/common.sh"


# Spin up EC2 instances and provision
function instance_launch() {
    run_playbook "launch" "$1"
    return $?
}

# Teardown all EC2 instances belonging to this project
function instance_teardown() {
    run_playbook "teardown" "$1"
    return $?
}
