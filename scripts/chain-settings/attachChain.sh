#!/bin/bash
# This script is used to boot up a specific chain with a genesis block

# Ensure the script received exactly two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 ./chain-dbs/db0/ ./chain-dbs/db0/geth.ipc"
    exit 1
fi

# echo "The script name: $0"
# echo "The first argument: $1"
# echo "The second argument: $2"

# Use the arguments in the command
# Example: attachChain.sh ./chain-dbs/db0/ ./chain-dbs/db0/geth.ipc

command_to_run="geth --datadir $1 --allow-insecure-unlock attach ipc:$2"

echo "Running command: $command_to_run"

# Execute the command
$command_to_run



