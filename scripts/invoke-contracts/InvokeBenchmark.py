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
    if func_name == "opVars":
        return_val = m_contractInst.functions.opVars().call()
    elif func_name == "bSort":
        return_val = m_contractInst.functions.bSort().call()
    elif func_name == "getGcd":
        return_val = m_contractInst.functions.getGcd().call()
    elif func_name == "fibonacci":
        return_val = m_contractInst.functions.fibonacci().call()
    elif func_name == "rwData":
        return_val = m_contractInst.functions.rwData().call()
    elif func_name == "isPrime":
        return_val = m_contractInst.functions.isPrime().call()
    elif func_name == "completeTask":
        return_val = m_contractInst.functions.completeTask(50).call()
    elif func_name == "updateState":
        return_val = m_contractInst.functions.updateState(2, 100).call()
    elif func_name == "vote":
        return_val = m_contractInst.functions.vote(8).call()
    
    end_time = time.time()
    execution_time = (end_time - start_time) * 1000
    logger.info(f"Return value: {return_val}")
    return execution_time



if __name__ == "__main__" :
    benchmark = OrderedDict([
        # micro
        ("BaseSample", "opVars"),
        ("BubbleSort", "bSort"),
        ("ComputeGcd", "getGcd"),
        ("Fibonacci", "fibonacci"),
        ("LoadStoreData", "rwData"),
        ("PrimeNumber", "isPrime"),
        # macro
        ("ChainGame", "completeTask"),
        ("SupplyChain", "updateState"),
        ("TheDAO", "vote")
    ])




    logger = logging.getLogger('logs')
    logger.setLevel(level=logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')

    # log path
    time_day = time.strftime("%Y%m%d/", time.localtime())
    log_path = './logs/' + time_day
    os.makedirs(log_path, exist_ok=True)
    
    time_sec = time.strftime("Benchmark_base_r1_%H%M%S.log", time.localtime())
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

    exe_times = OrderedDict((key, []) for key in benchmark.keys())
    dep_addrs = OrderedDict((key, []) for key in benchmark.keys())
    for r in range(5):
        for contr, func in benchmark.items():
            CONTRACT_ABI = '../contracts/benchmark/' + contr + '.abi'
            CONTRACT_BIN = '../contracts/benchmark/' + contr + '.bin'
            execution_times = []
            deployed_addrs = []
            for i in range(10):
                logger.info(f"===============round:**{r}**===step:**{i}**===============")

                m_contractAddress = deploy(CONTRACT_ABI, CONTRACT_BIN)
                deployed_addrs.append(m_contractAddress)
                logger.info("Deploy contract:")
                logger.info(contr)

                logger.info("Executing contract address:")
                logger.info(m_contractAddress)
                execution_time = invoke(m_contractAddress, CONTRACT_ABI, func)
                execution_times.append(execution_time)
                logger.info(f"Execution time:  {execution_time} ms\n\n")
            exe_times[contr].append(execution_times)
            dep_addrs[contr].append(deployed_addrs)
    logger.info("End execution process.\n\n\n")

    average_latency = []
    rectify30_average_latency = []
    contract_names = benchmark.keys()
    for c_name in contract_names:
        logger.info(f"===================== Results =====================\n")
        execution_times = exe_times[c_name]
        deployed_addrs = dep_addrs[c_name]
        logger.info(f"Contract name:\n {c_name}")
        logger.info(f"Each execution time(ms):\n  {execution_times}")

        flattened_times = [item for sublist in execution_times for item in sublist]
        avg_time = sum(flattened_times)/len(flattened_times)

        r30_flattened_times = [item for item in flattened_times if item <= 1.3*avg_time ]
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