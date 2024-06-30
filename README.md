# CROSC
In this paper, we propose CROSC, a compilation-runtime joint optimization approach to improve state access efficiency and storage utilization. 
To our knowledge, we are the first to address this issue from a compilation-runtime joint optimization perspective.
CROSC consists of three key parts:
1) a runtime memory management mechanism named fast state memory (FastSM) to fully utilize the working memory and provide interfaces for the up-level smart contract compiler,
2) a state variable address relocation (SVAR) strategy to minimize the execution of costly persistent storage operation instructions by precisely relocating state variable access targets, and 
3) a compact storage method that eliminates the reliance on the order of state variable declarations without additional decompression overhead.
We implement CROSC based on Solc v0.8.18 and EVM embedded in Geth v1.11.0.

Extensive experimental results highlight that compared with the baseline compilation and runtime system of Ethereum, 
CROSC can achieve the speedup of 2.4 $\times$ and 6.9 $\times$ for the single state read operation and write operation, respectively.
CROSC reduces state access latency by up to 86.89%, and reduces overall contract execution latency by an average of 18.44% across four types of contracts, with a maximum reduction of 28.95%.
Moreover, CROSC achieves a notable reduction in storage space overhead.

Baseline compiler and client:
- [Solc v0.8.18](https://github.com/ethereum/solidity/tree/v0.8.18)
- [EVM embedded in Geth v1.11.0](https://github.com/ethereum/go-ethereum/tree/v1.11.0)


# Table of Contents 
<!-- Introduction -->
This repository includes 4 sub-directories as follows:
- ```benchmark-contracts``` Stores the smart contracts in our experimental benchmarks.
- ```crosc-geth``` Our implementation of contract runtime environment build on [Geth v1.11.0](https://github.com/ethereum/go-ethereum/tree/v1.11.0).
- ```crosc-solc``` Our implementation of contract compiler based on [Solc v0.8.18](https://github.com/ethereum/solidity/tree/v0.8.18).
- ```scripts``` Scripts for building Ethereum test network, and deploying and invoking smart contracts on test net.


