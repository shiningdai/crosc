from web3.auto import w3
import json
import time
import logging
import os,sys
from collections import OrderedDict
os.chdir(sys.path[0])


def deploy(CONTRACT_ABI, CONTRACT_BIN):
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    with open(CONTRACT_BIN, 'r') as f:
        code = f.read()
    gas_estimate = w3.eth.estimateGas({'data':code})
    logger.info("gas_estimate:")
    logger.info(gas_estimate)
    m_Contract = w3.eth.contract(bytecode=code, abi=abi)
    accounts = w3.eth.accounts
    option = {'from': accounts[0], 'gas': gas_estimate}
    w3.geth.personal.unlock_account(accounts[0], '001')
    tx_hash = m_Contract.constructor().transact(option)

    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    logger.info("tx_receipt:")
    logger.info(tx_receipt)
    logger.info("tx_receipt.contractAddress:")
    logger.info(tx_receipt.contractAddress)
    return tx_receipt.contractAddress

def invoke(contractAddress, CONTRACT_ABI, func_name):
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    start_time = time.time()
    m_address = w3.toChecksumAddress(contractAddress)
    m_contractInst = w3.eth.contract(m_address, abi=abi)
    logger.info(f"Calling contract function {func_name}()...... ")
    if func_name == "allowance":
        return_val = m_contractInst.functions.allowance(1).call()
    elif func_name == "approve":
        return_val = m_contractInst.functions.approve(1, 500).call()
    elif func_name == "balanceOf":
        return_val = m_contractInst.functions.balanceOf(1).call()
    elif func_name == "getTotalSupply":
        return_val = m_contractInst.functions.getTotalSupply().call()
    elif func_name == "transfer":
        return_val = m_contractInst.functions.transfer(1, 200).call()
    
    end_time = time.time()
    execution_time = (end_time - start_time) * 1000
    logger.info(f"Return value: {return_val}")
    return execution_time



if __name__ == "__main__" :
    
    erc20 = ["allowance", "approve", "balanceOf", "getTotalSupply", "transfer"]

    logger = logging.getLogger('logs')
    logger.setLevel(level=logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')

    # log path
    time_day = time.strftime("%Y%m%d/", time.localtime())
    # modify parameter： round1， round2
    log_path = './logs/' + time_day
    os.makedirs(log_path, exist_ok=True)
    
    time_sec = time.strftime("ERC20_base_%H%M%S.log", time.localtime())
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


    exe_times = OrderedDict((key, []) for key in erc20)
    dep_addrs = OrderedDict((key, []) for key in erc20)
    for r in range(5):
        CONTRACT_ABI = '../contracts/erc20/SampleERC20.abi'
        CONTRACT_BIN = '../contracts/erc20/SampleERC20.bin'
        for func in erc20:
            execution_times = []
            deployed_addrs = []
            for i in range(10):
                logger.info(f"===============round:**{r}**===step:**{i}**===============")
                m_contractAddress = deploy(CONTRACT_ABI, CONTRACT_BIN)
                deployed_addrs.append(m_contractAddress)
                logger.info(f"Executing contract function: {func}")
                logger.info(f"Executing contract address: {m_contractAddress}")
                execution_time = invoke(m_contractAddress, CONTRACT_ABI, func)
                execution_times.append(execution_time)
                logger.info(f"Execution time: {execution_time} ms\n\n")
            exe_times[func].append(execution_times)
            dep_addrs[func].append(deployed_addrs)
    logger.info("End execution process.\n\n\n")

    average_latency = []
    rectify30_average_latency = []
    for func in erc20:
        logger.info(f"===================== Results =====================\n")
        execution_times = exe_times[func]
        deployed_addrs = dep_addrs[func]
        logger.info(f"Contract name:\n {func}")
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

    logger.info(f"**************** All Contract Addresses ****************")
    logger.info(f"All Contract Addresses:\n  {dep_addrs}\n\n")


    logger.info(f"**************** All Average Latency ****************")
    logger.info(f"All Average Latency:\n  {average_latency}\n\n")
    logger.info(f"Rectify 30% Average Latency:\n  {rectify30_average_latency}\n\n")

    logger.info("End program executing!\n\n\n")