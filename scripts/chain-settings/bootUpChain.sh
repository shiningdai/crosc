#!/bin/bash
# This script is used to boot up a specific chain with a genesis block

# Ensure the script received exactly two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 ./chain-dbs/db0/ ./chain-dbs/chain-logs/basechainlog_2410081.log"
    exit 1
fi

# echo "The script name: $0"
# echo "The first argument: $1"
# echo "The second argument: $2"

# Use the arguments in the command
# Example: bootUpChain.sh ./chain-dbs/db0/ ./chain-dbs/chain-logs/basechainlog_2410081.log

# command_to_run="geth --identity "BaseChain1" --datadir $1 --networkid 1001 --port "60000" --http --http.api "db,personal,eth,net,web3" -nodiscover --snapshot=false --allow-insecure-unlock console 2>> $2"
command_to_run="geth --identity "BaseChain2" --datadir $1 --networkid 1001 --port "60000" --http --http.api "db,personal,eth,net,web3" -nodiscover --snapshot=false --allow-insecure-unlock console 2>> $2"
# 
echo "Running command: $command_to_run"

# Execute the command
# $command_to_run
eval $command_to_run


