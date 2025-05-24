from web3.auto import w3
import json
import time
import logging
import os, sys
from collections import OrderedDict

os.chdir(sys.path[0])

# Dictionary mapping contracts to their functions - moved from call_contracts.py
contracts_map = OrderedDict([
    # ERC20 contracts
    ("BecToken", [
        "approve", "balanceOf", "batchTransfer", 
        "togglePause", "transfer", "transferFrom"
    ]),
    ("EKT", [
        "allowance", "approve", "balanceOf", 
        "transfer", "transferFrom"
    ]),
    ("HoloToken", [
        "adjustAllowance", "approve", "balanceOf", 
        "transfer", "transferFrom"
    ]),
    ("InsightChainToken", [
        "allowance", "approve", "balanceOf", "transfer"
    ]),
    ("ZRXToken", [
        "allowance", "approve", "balanceOf", 
        "totalSupply", "transfer"
    ]),

    # ERC721 contracts
    ("BlockCities", [
        "burn", "getAttribute", "mint", "queryToken", 
        "setAttribute", "supplyInfo", "transfer"
    ]),
    ("Clovers", [
        "balanceOf", "burnToken", "getAttr", 
        "mintToken", "query", "setAttr", "transfer"
    ]),
    ("DozerDoll", [
        "getProperty", "getSymValue", "manageToken", 
        "setProperty", "setSymValue", "totalSupply"
    ]),
    ("EggStorage", [
        "balanceOf", "getEggProperty", "manageEgg", 
        "push", "remove", "tokenOperation"
    ]),
    ("KingdomsBeyond", [
        "balanceOf", "burn", "getOwner", 
        "mint", "transfer"
    ])
])

# Parameters for each function in each contract - moved from call_contracts.py
function_params = {
    # ERC20 contracts
    "BecToken": {
        "approve": [2, 300],
        "balanceOf": [1],
        "batchTransfer": [100],
        "togglePause": [1],
        "transfer": [2, 300],
        "transferFrom": [1, 2, 200]
    },
    "EKT": {
        "allowance": [1, 2],
        "approve": [2, 600],
        "balanceOf": [1],
        "transfer": [0, 500],
        "transferFrom": [1, 2, 400]
    },
    "HoloToken": {
        "adjustAllowance": [1, 0, 300, 1],
        "approve": [0, 1, 1500],
        "balanceOf": [0],
        "transfer": [0, 1, 500],
        "transferFrom": [0, 1, 600]
    },
    "InsightChainToken": {
        "allowance": [],
        "approve": [200],
        "balanceOf": [],
        "transfer": [300]
    },
    "ZRXToken": {
        "allowance": [1, 2],
        "approve": [1, 2, 500],
        "balanceOf": [1],
        "totalSupply": [],
        "transfer": [1, 2, 300]
    },

    # ERC721 contracts
    "BlockCities": {
        "burn": [1, 1],
        "getAttribute": [1, 0],
        "mint": [1, 1],
        "queryToken": [0, 1],
        "setAttribute": [1, 100, 2],
        "supplyInfo": [1],
        "transfer": [1, 2, 1]
    },
    "Clovers": {
        "balanceOf": [0],
        "burnToken": [1],
        "getAttr": [1, 1],
        "mintToken": [0, 1],
        "query": [1, 0],
        "setAttr": [1, 2, 100],
        "transfer": [1, 2]
    },
    "DozerDoll": {
        "getProperty": [1, 1],
        "getSymValue": [2],
        "manageToken": [1, 2, 11],
        "setProperty": [1, 10],
        "setSymValue": [3, 500],
        "totalSupply": []
    },
    "EggStorage": {
        "balanceOf": [1],
        "getEggProperty": [1, 3],
        "manageEgg": [1, 22, 0],
        "push": [1, 5],
        "remove": [1, 1],
        "tokenOperation": [1, 2, 1]
    },
    "KingdomsBeyond": {
        "balanceOf": [1],
        "burn": [1],
        "getOwner": [2],
        "mint": [1, 2],
        "transfer": [1, 2, 1]
    }
}


def setup_logger():
    logger = logging.getLogger('solythesis_logs')
    logger.setLevel(level=logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')

    # Create log directory
    time_day = time.strftime("%Y%m%d/", time.localtime())
    log_path = './logs/' + time_day
    os.makedirs(log_path, exist_ok=True)
    
    time_sec = time.strftime("solythesis_ours_%H%M%S.log", time.localtime())
    log_file = log_path + time_sec
    
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(level=logging.INFO)
    file_handler.setFormatter(formatter)

    # stream_handler = logging.StreamHandler()
    # stream_handler.setLevel(logging.INFO)
    # stream_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    # logger.addHandler(stream_handler)
    
    return logger

def deploy(CONTRACT_ABI, CONTRACT_BIN, logger):
    # Read ABI and BIN
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    with open(CONTRACT_BIN, 'r') as f:
        code = f.read()
    
    # Estimate gas
    gas_estimate = w3.eth.estimateGas({'data': code})
    logger.info(f"Gas estimate: {gas_estimate}")
    
    m_Contract = w3.eth.contract(bytecode=code, abi=abi)
    
    # Deploy contract
    accounts = w3.eth.accounts
    option = {'from': accounts[0], 'gas': gas_estimate}
    
    w3.geth.personal.unlock_account(accounts[0], '1001')
    tx_hash = m_Contract.constructor().transact(option)

    # Wait for mining
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    logger.info(f"Contract deployed at: {tx_receipt.contractAddress}")
    
    return tx_receipt.contractAddress

def invoke_function(contract_address, abi, function_name, params=None, logger=None):
    m_address = w3.toChecksumAddress(contract_address)
    m_contractInst = w3.eth.contract(m_address, abi=abi)
    
    start_time = time.time()
    
    try:
        # Call the function with or without parameters
        if params is None:
            result = m_contractInst.functions[function_name]().call()
        else:
            # if isinstance(params, tuple):
            if isinstance(params, (list, tuple)):  # Check for both list and tuple
                result = m_contractInst.functions[function_name](*params).call()
            else:
                result = m_contractInst.functions[function_name](params).call()
        
        end_time = time.time()
        execution_time = (end_time - start_time) * 1000
        
        if logger:
            logger.info(f"Function {function_name} executed in {execution_time:.2f} ms")
            logger.info(f"Result: {result}")
        
        return execution_time, result
    except Exception as e:
        if logger:
            logger.error(f"Error executing {function_name}: {str(e)}")
        return None, None

def test_contracts():
    logger = setup_logger()
    
    global_start_time = time.time()

    logger.info("Starting Solythesis contract tests")
    logger.info(f"Connected to node: {w3.isConnected()}")
    logger.info(f"Current block number: {w3.eth.blockNumber}")
    
    # Create nested dictionaries to store execution times and deployed addresses
    # Format: {"contract_name": {"function_name": [execution_times]}}
    exe_times = OrderedDict()
    # Format: {"contract_name": {"function_name": [contract_addresses]}}
    dep_addrs = OrderedDict()
    
    for contract_name in contracts_map.keys():
        exe_times[contract_name] = OrderedDict()
        dep_addrs[contract_name] = OrderedDict()
        for function_name in contracts_map[contract_name]:
            exe_times[contract_name][function_name] = []
            dep_addrs[contract_name][function_name] = []
    
    # Run 4,6 rounds of experiments
    total_rounds = 6
    for r in range(total_rounds):
        print(f"\n{'='*50}\nStarting round {r+1}/{total_rounds}\n{'='*50}")
        logger.info(f"\n\n{'='*50}\nStarting round {r+1}/{total_rounds}\n{'='*50}")
        
        for contract_name, functions in contracts_map.items():
            logger.info(f"\n{'='*40}\nTesting contract: {contract_name}\n{'='*40}")
            
            CONTRACT_ABI = f'../contracts/solythesis/{contract_name}.abi'
            CONTRACT_BIN = f'../contracts/solythesis/{contract_name}.bin'
            
            with open(CONTRACT_ABI, 'r') as f:
                abi = json.load(f)
            
            # For each function in the contract
            for function_name in functions:
                logger.info(f"\n{'='*30}\nTesting function: {function_name}\n{'='*30}")
                
                params = function_params[contract_name].get(function_name)
                
                # Skip if no parameters are defined
                if params is None:
                    logger.info(f"Skipping {function_name} - no parameters defined")
                    continue
                
                # Convert single value to tuple if needed
                if not isinstance(params, tuple) and not isinstance(params, list):
                    params = (params,)
                
                logger.info(f"Using parameters: {params}")
                
                # Store execution times and contract addresses for this function in this round
                round_execution_times = []
                round_addresses = []
                
                # Run 5 executions per function
                for i in range(5):
                    logger.info(f"Execution {i+1}/5 for {contract_name}.{function_name}")
                    
                    try:
                        # Deploy a fresh contract for each function call
                        contract_address = deploy(CONTRACT_ABI, CONTRACT_BIN, logger)
                        round_addresses.append(contract_address)
                        
                        # Call the specific function with its parameters
                        execution_time, result = invoke_function(contract_address, abi, function_name, params, logger)
                        
                        if execution_time is not None:
                            round_execution_times.append(execution_time)
                            logger.info(f"Execution time: {execution_time:.2f} ms")
                        else:
                            logger.error(f"Error executing {function_name}")
                            
                    except Exception as e:
                        logger.error(f"Error in deployment-invocation cycle: {str(e)}")
                        return
                
                # Store results for this function in this round
                exe_times[contract_name][function_name].append(round_execution_times)
                dep_addrs[contract_name][function_name].append(round_addresses)
    
    # Summarize results
    logger.info("\n\n" + "="*70)
    logger.info("TEST SUMMARY")
    logger.info("="*70)
    
    # Calculate average execution times across all rounds for each function
    all_average_latencies = []
    
    for contract_name, function_results in exe_times.items():
        logger.info(f"\n{'='*40}\nContract: {contract_name}\n{'='*40}")
        
        for function_name, round_times in function_results.items():
            logger.info(f"\nFunction: {function_name}")
            
            # Get the addresses for this function
            function_addresses = dep_addrs[contract_name][function_name]
            
            logger.info(f"Each execution time(ms):\n{round_times}")
            
            # Flatten the list of execution times for this function
            flattened_times = [time for round_list in round_times for time in round_list]
            
            if flattened_times:
                avg_time = sum(flattened_times) / len(flattened_times)
                all_average_latencies.append(avg_time)
                logger.info(f"Average execution time: {avg_time:.2f} ms")
            else:
                logger.info("No valid execution times recorded")
            
            logger.info(f"Contract addresses for this function:\n{function_addresses}")
    
    # Output all contract addresses in the requested format
    logger.info(f"\n\n{'*'*50}\nAll Contract Addresses\n{'*'*50}")
    logger.info(f"All Contract Addresses by Function:\n{dep_addrs}")
    
    # Output all average latencies
    logger.info(f"\n\n{'*'*50}\nAll Average Latency\n{'*'*50}")
    logger.info(f"All Average Latency:\n{all_average_latencies}")
    
    # end program
    global_execution_time = (time.time() - global_start_time)
    logger.info(f"Global execution time: {global_execution_time} s\n\n")
    logger.info("End program executing!\n\n\n")

    print("End program executing!\n")
    print(f"Global execution time: {global_execution_time} s\n\n")

if __name__ == "__main__":
    test_contracts()
