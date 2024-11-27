#!/bin/bash
# This script is used to initialize a chain with a genesis block

# Ensure the script received exactly two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
fi

echo "The script name: $0"
echo "The first argument: $1"
echo "The second argument: $2"

# Use the arguments in the command
# Example: initChain.sh ./chain-dbs/db0/ ./gensis-configs/gensis_db0.json
# geth --datadir ./chain-dbs/db0/ init ./gensis-configs/gensis_db0.json
command_to_run="geth --datadir $1 init $2"

echo "Running command: $command_to_run"

# Execute the command
$command_to_run