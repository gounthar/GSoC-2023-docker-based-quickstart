#!/bin/bash
set -exo pipefail

# Assign the first argument passed to the script to the variable TUTORIAL
TUTORIAL=$1
echo "TUTORIAL: $TUTORIAL"

# Assign values 1-4 to variables VAR1-VAR4 can be changed in future to maven, nodejs, python
VAR1=1
VAR2=2
VAR3=3
VAR4=4
echo "VAR1: $VAR1"
echo "VAR2: $VAR2"
echo "VAR3: $VAR3"
echo "VAR4: $VAR4"

# Assign file paths to variables VAR0-VAR3L
VARDL="."
VAR4L="./03_maven_tutorial"
DOCKER_COMPOSE="docker compose"

# Function to check if running in Gitpod and modify jenkins.yaml if needed
# I created this one yesterday but it's not needed after last PR that got merged which solves this issue 
check_gitpod() {
    if [ -e /ide/bin/gitpod-code ] && [ -v GITPOD_REPO_ROOT ]; then
        echo "Gitpod detected"
        echo "Changing URL in jenkins.yaml that supports Gitpod"
        local tutorial_path=$1
        sh $tutorial_path/gitpodURL.sh
    fi
}

check_running_tutorials() {
    # Check if there is a .tutorials_running.txt file, if there is then check if it's empty, if not stops the script
    if [ ! -f ./.tutorials_running.txt ]; then
        echo "Running First Tutorial"
    else
        if [ -s .tutorials_running.txt ]; then
            echo "Another Tutorial is running, Please use ./jenkins_teardown.sh first"
            exit 1
        fi
    fi 
}

DOCKER_COMPOSE="docker compose"

# Function to generate ssh keys 
generate_ssh_keys() {
  local tutorial_path=$1
  echo "generating new ssh keys"
  bash $tutorial_path/keygen.sh $tutorial_path
}

# Function to start a tutorial based on the provided path
start_tutorial() {
  local tutorial_path=$1
  echo "Starting tutorial $tutorial_path"
  $DOCKER_COMPOSE -f "$tutorial_path/docker-compose.yaml" up -d
}

# Check Docker Compose installation
check_docker_compose

# if tutorials are already running 
check_running_tutorials

# Determine the tutorial to start based on the provided argument
if [[ "$TUTORIAL" == "$VAR1" ]]; then
  start_tutorial "$VAR1L"
elif [[ "$TUTORIAL" == "$VAR2" ]]; then
  start_tutorial "$VAR2L"
elif [[ "$TUTORIAL" == "$VAR3" ]]; then
  generate_ssh_keys "$VAR3L"
  start_tutorial "$VAR3L"
elif [[ "$TUTORIAL" == "$VAR4" ]]; then
  generate_ssh_keys "$VAR4L"
  start_tutorial "$VAR4L"
else
  # If no valid argument was passed, run the default tutorial
  echo "No valid argument was selected. Running the default tutorial"
  generate_ssh_keys "$VARDL"
  start_tutorial "$VARDL"
fi

# Track which tutorials have been run for teardown command
echo "$TUTORIAL"
if [[ -z "$TUTORIAL" ]]; then
    echo "0" >> ./.tutorials_running.txt
else
  echo "$TUTORIAL" >> ./.tutorials_running.txt
fi
