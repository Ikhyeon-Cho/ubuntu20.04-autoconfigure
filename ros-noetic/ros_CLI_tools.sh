#!/bin/bash

parse_ros_workspace() {
    local ros_ws
    local IFS=:
    local paths=($ROS_PACKAGE_PATH)
    
    for path in "${paths[@]}"; do
        if [[ "$path" == *"_ws/src"* ]]; then
            ros_ws="${path%"_ws/src"*}"
            ros_ws="${ros_ws##*/}"
#            ros_ws+="_ws"
            break
        fi
    done

    if [ -n "$ros_ws" ]; then
        echo "%F{green}$ros_ws%f"
    fi
}


# Using RPrompt for displaying ROS Workspace
RPROMPT='$(parse_ros_workspace)'


print_current_workspace_packages() {
    local ros_ws
    ros_ws=$(echo "$ROS_PACKAGE_PATH" | awk -F':' '/_ws\/src/ {print $1}')
    
    if [ -n "$ros_ws" ]; then
        (cd "$ros_ws" && echo && catkin list && echo)
    else
        echo "No catkin workspace found in the current ROS_PACKAGE_PATH."
    fi
}

print_ros_package_path() {
    echo "$ROS_PACKAGE_PATH" | tr ':' '\n'
}


## Alias for ROS
# ROS Packages in Workspace
alias rpl='print_current_workspace_packages'
alias rpp='print_ros_package_path'

# ROS Workspace
alias rw='cd ~/ros && cd'
alias rwl='cd ~/ros && ls -l'
alias uw='source devel/setup.zsh'

# ROS Build
alias cb='catkin build -DCMAKE_BUILE_TYPE=release'
alias cbdbg='catkin build -DCMAKE_BUILE_TYPE=debug'
alias cm='catkin_make -DCMAKE_BUILE_TYPE=release'
alias cmdbg='catkin_make -DCMAKE_BUILE_TYPE=debug'
