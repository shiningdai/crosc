from web3.auto import w3
import json
import time
import logging
import os,sys
from collections import OrderedDict
os.chdir(sys.path[0])


def deploy(CONTRACT_ABI, CONTRACT_BIN):
    # 读取文件中的abi和bin
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    with open(CONTRACT_BIN, 'r') as f:
        code = f.read()
    # 预估gas消耗
    gas_estimate = w3.eth.estimateGas({'data':code})
    logger.info("gas_estimate:")
    logger.info(gas_estimate)
    m_Contract = w3.eth.contract(bytecode=code, abi=abi)
    # 发起交易部署合约
    accounts = w3.eth.accounts
    option = {'from': accounts[0], 'gas': gas_estimate}
    w3.geth.personal.unlock_account(accounts[0], '2001')
    tx_hash = m_Contract.constructor().transact(option)

    # 等待挖矿使得交易成功
    # tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    logger.info("tx_receipt:")
    logger.info(tx_receipt)
    logger.info("tx_receipt.contractAddress:")
    logger.info(tx_receipt.contractAddress)
    # 0x43EAcdA930fF1F0cB07b4C428e9771A69917a555
    return tx_receipt.contractAddress

def invoke(contractAddress, CONTRACT_ABI, para):
    # 调用合约
    # 读取文件中的abi
    with open(CONTRACT_ABI, 'r') as f:
        abi = json.load(f)
    # 开始时间
    start_time = time.time()
    m_address = w3.toChecksumAddress(contractAddress)
    m_contractInst = w3.eth.contract(m_address, abi=abi)

    return_val = m_contractInst.functions.withdrawAll(para).call()
    
    
    # 结束时间
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
    
    time_sec = time.strftime("caseStudy_base_%H%M%S.log", time.localtime())
    log_file = log_path + time_sec
    
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(level=logging.INFO)
    file_handler.setFormatter(formatter)

    # stream_handler = logging.StreamHandler()
    # stream_handler.setLevel(logging.INFO)
    # stream_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    # logger.addHandler(stream_handler)

    logger.info("isConnected: " + str(w3.isConnected()))
    logger.info("Block number: " + str(w3.eth.blockNumber))

    paras = [500, 1000, 1500, 2000, 2500, 3000, 3500]

    global_start_time = time.time()

    # 每组实验每个合约执行5次，共4组20次，最终结果取平均值
    # exe_times = {key: [] for key in benchmark.keys()}
    # dep_addrs = {key: [] for key in benchmark.keys()}
    contract_names = [f"DispatchContractV{para}" for para in paras]
    exe_times = OrderedDict((key, []) for key in contract_names)
    dep_addrs = OrderedDict((key, []) for key in contract_names)
    total_rounds = 5
    for r in range(total_rounds):
        print(f"\n{'='*50}\nStarting round {r+1}/{total_rounds}\n{'='*50}")
        logger.info(f"\n\n{'='*50}\nStarting round {r+1}/{total_rounds}\n{'='*50}")
        for para in paras:
            CONTRACT_ABI = '../contracts/benchtcr1/DispatchContract.abi'
            CONTRACT_BIN = '../contracts/benchtcr1/DispatchContract.bin'
            contr = f"DispatchContractV{para}"
            execution_times = []
            deployed_addrs = []
            for i in range(10):
                # 部署合约
                m_contractAddress = deploy(CONTRACT_ABI, CONTRACT_BIN)
                deployed_addrs.append(m_contractAddress)
                logger.info("Deploy contract:")
                logger.info(contr)
                # 调用合约方法
                logger.info("Executing contract address:")
                logger.info(m_contractAddress)
                execution_time = invoke(m_contractAddress, CONTRACT_ABI, para)
                execution_times.append(execution_time)
                logger.info(f"Execution time:  {execution_time} ms\n\n")
            exe_times[contr].append(execution_times)
            dep_addrs[contr].append(deployed_addrs)
    logger.info("End execution process.\n\n\n")

    # present results
    average_latency = []
    for c_name in contract_names:
        logger.info(f"===================== Results =====================\n")
        execution_times = exe_times[c_name]
        deployed_addrs = dep_addrs[c_name]
        logger.info(f"Contract name:\n {c_name}")
        logger.info(f"Each execution time(ms):\n  {execution_times}")
        flattened_times = [item for sublist in execution_times for item in sublist]
        avg_time = sum(flattened_times)/len(flattened_times)
        average_latency.append(avg_time)
        logger.info(f"Average execution time:\n  {avg_time} ms")
        logger.info(f"Contract addresses:\n  {deployed_addrs}\n\n")

    # average_latency = []
    # for c_name in contract_names:
    #     average_latency.append(sum(exe_times[c_name])/len(exe_times[c_name]))
    logger.info(f"**************** All Average Latency ****************")
    logger.info(f"All Average Latency:\n  {average_latency}\n\n")


    # 集中输出合约地址
    logger.info(f"**************** All Contract Addresses ****************")  
    logger.info(f"All Contract Addresses:\n\n  {dep_addrs}\n\n")


    # end program
    global_execution_time = (time.time() - global_start_time)
    logger.info(f"Global execution time: {global_execution_time} s\n\n")
    logger.info("End program executing!\n\n\n")

    print("End program executing!\n")
    print(f"Global execution time: {global_execution_time} s\n\n")