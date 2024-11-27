from web3.auto import w3
import json
import time
import logging
import os,sys
from collections import OrderedDict
os.chdir(sys.path[0])


def deploy(CONTRACT_ABI, CONTRACT_BIN):
    # Read the ABI and BIN files
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    with open(CONTRACT_BIN, 'r') as f:
        code = f.read()
    # Estimate gas consumption
    gas_estimate = w3.eth.estimateGas({'data':code})
    logger.info("gas_estimate:")
    logger.info(gas_estimate)
    m_Contract = w3.eth.contract(bytecode=code, abi=abi)
    # Initiate transaction to deploy contract
    accounts = w3.eth.accounts
    option = {'from': accounts[0], 'gas': gas_estimate}
    w3.geth.personal.unlock_account(accounts[0], '001')
    tx_hash = m_Contract.constructor().transact(option)

    # Wait for mining to make the transaction successful
    # tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    logger.info("tx_receipt:")
    logger.info(tx_receipt)
    logger.info("tx_receipt.contractAddress:")
    logger.info(tx_receipt.contractAddress)
    # 0x43EAcdA930fF1F0cB07b4C428e9771A69917a555
    return tx_receipt.contractAddress

def invoke(contractAddress, CONTRACT_ABI):
    # Invoke contract
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    # Start time
    start_time = time.time()
    m_address = w3.toChecksumAddress(contractAddress)
    m_contractInst = w3.eth.contract(m_address, abi=abi)
    logger.info("Calling contract function opVars()...... ")
    # Call the opVars() method of BaseSampleVx.sol
    return_val = m_contractInst.functions.opVars().call()
    # End time
    end_time = time.time()
    execution_time = (end_time - start_time) * 1000
    logger.info(f"Return value: {return_val}")
    return execution_time



if __name__ == "__main__" :

    logger = logging.getLogger('logs')
    logger.setLevel(level=logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')

    # log path
    time_day = time.strftime("%Y%m%d/", time.localtime())
    # modify parameter： round1， round2
    log_path = './logs/' + time_day
    os.makedirs(log_path, exist_ok=True)
    
    time_sec = time.strftime("CaseStudy_base_%H%M%S.log", time.localtime())
    log_file = log_path + time_sec
    
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(level=logging.INFO)
    file_handler.setFormatter(formatter)

    stream_handler = logging.StreamHandler()
    stream_handler.setLevel(logging.INFO)
    stream_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(stream_handler)

    logger.info("isConnected: " + str(w3.isConnected()))
    logger.info("Block number: " + str(w3.eth.blockNumber))

    paras = [100, 500, 1000, 1500, 2000, 2500, 3000]
    contr_versions = ['BaseSampleV'+str(num) for num in paras]
    # Each group of experiments executes each contract 10 times, 
    # for a total of 5 groups and 50 times, and the final result is averaged
    exe_times = OrderedDict((key, []) for key in contr_versions)
    dep_addrs = OrderedDict((key, []) for key in contr_versions)
    for r in range(5):
        for contr in contr_versions:
            CONTRACT_ABI = '../contracts/casestudy/' + contr + '.abi'
            CONTRACT_BIN = '../contracts/casestudy/' + contr + '.bin'
            execution_times = []
            deployed_addrs = []
            for i in range(10):
                logger.info(f"===============round:**{r+1}**===step:**{i+1}**===============")
                # deploy contract
                m_contractAddress = deploy(CONTRACT_ABI, CONTRACT_BIN)
                deployed_addrs.append(m_contractAddress)
                # invoke contract function
                logger.info(f"Executing contract: {contr}")
                logger.info(f"Executing contract address: {m_contractAddress}")
                execution_time = invoke(m_contractAddress, CONTRACT_ABI)
                execution_times.append(execution_time)
                logger.info(f"Execution time: {execution_time} ms\n\n")
            exe_times[contr].append(execution_times)
            dep_addrs[contr].append(deployed_addrs)
    logger.info("End execution process.\n\n\n")

    # present results
    average_latency = []
    rectify30_average_latency = []
    for contr in contr_versions:
        logger.info(f"===================== Results =====================\n")
        execution_times = exe_times[contr]
        deployed_addrs = dep_addrs[contr]
        logger.info(f"Contract name:\n {contr}")
        logger.info(f"Each execution time(ms):\n  {execution_times}")

        flattened_times = [item for sublist in execution_times for item in sublist]
        avg_time = sum(flattened_times)/len(flattened_times)

        r30_flattened_times = [item for item in flattened_times if item <= 1.3*avg_time]
        r30_avg_time = sum(r30_flattened_times)/len(r30_flattened_times)
        
        average_latency.append(avg_time)
        rectify30_average_latency.append(r30_avg_time)

        logger.info(f"Average execution time:\n {len(flattened_times)} groups {avg_time} ms")
        logger.info(f"Rectify30 average execution time:\n {len(r30_flattened_times)} groups {r30_avg_time} ms")
        logger.info(f"Contract addresses:\n  {deployed_addrs}\n\n")

    # combine all contract addresses
    logger.info(f"**************** All Contract Addresses ****************")
    logger.info(f"All Contract Addresses:\n  {dep_addrs}\n\n")

    # average_latency = []
    # for c_name in contract_names:
    #     average_latency.append(sum(exe_times[c_name])/len(exe_times[c_name]))
    logger.info(f"**************** All Average Latency ****************")
    logger.info(f"All Average Latency:\n  {average_latency}\n\n")
    logger.info(f"Rectify 30% Average Latency:\n  {rectify30_average_latency}\n\n")

    logger.info("End program executing!\n\n\n")