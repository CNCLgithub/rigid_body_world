#!/bin/bash

cd "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

. load_config.sh

# Define the path to the container and conda env
CONT="${ENV['cont']}"

# Parse the incoming command
COMMAND="$@"

# Enter the container and run the command
SING="${ENV['path']} exec --nv"
mounts=(${ENV[mounts]})
BS=""
for i in "${mounts[@]}";do
    if [[ $i ]]; then
        BS="${BS} -B $i:$i"
    fi
done
for i in "${!PATHS[@]}"
do
  BS="${BS} -B ${PATHS[$i]}:/$i"
done

# add the repo path to "/project"
BS="${BS} -B ${PWD}:/project"


${SING} ${BS} ${CONT} bash -c "source activate /project/${ENV[env]} \
        && cd $PWD \
        && exec $COMMAND \
        && source deactivate"