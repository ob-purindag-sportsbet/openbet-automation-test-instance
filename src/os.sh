[ $OS_SH ] && return || OS_SH=1

os_family=""

function detect_os() {
    if [ "$(uname)" == "Darwin" ]; then
        os_family="OSX"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        os_family="Linux"
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        os_family="Windows"
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        os_family="Windows"
    fi
}
