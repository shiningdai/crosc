# CROSC
CROSC is a compilation-runtime joint optimization approach to accelerate smart contract execution, focusing on improving state access efficiency by minimizing direct access to costly persistent storage.
CROSC consists of three key parts:
1) a runtime memory management mechanism named Fast State Memory (FastSM) to fully utilize the working memory and provide the context for the contract compiler;
2) a State Variable Address Relocation (SVAR) strategy to minimize costly persistent storage operations by precisely redirecting state variable access targets during compilation;
3) a one-shot unpacking design that eliminates frequent decoding overhead for low-bitwidth state variables.
We implement CROSC based on Solc v0.8.18 and EVM embedded in Geth v1.11.0.

Extensive experimental results highlight that, compared with the baseline compilation and runtime system of Ethereum, CROSC can achieve 2.4× and 7.7× speedups for single state load and store operations, respectively. 
CROSC reduces state access latency by up to 81.3%, and overall contract execution latency by 29.7% on average across nine typical types of smart contracts.


Baseline compiler and client:
- [Solc v0.8.18](https://github.com/ethereum/solidity/tree/v0.8.18)
- [EVM embedded in Geth v1.11.0](https://github.com/ethereum/go-ethereum/tree/v1.11.0)


# Table of Contents 
<!-- Introduction -->
This repository includes 4 sub-directories as follows:
- ```benchmark``` Stores the smart contracts in our experimental benchmarks.
- ```crosc-geth``` Our implementation of contract runtime environment build on [Geth v1.11.0](https://github.com/ethereum/go-ethereum/tree/v1.11.0).
- ```crosc-solc``` Our implementation of contract compiler based on [Solc v0.8.18](https://github.com/ethereum/solidity/tree/v0.8.18).
- ```scripts``` Scripts for building Ethereum test network, and deploying and invoking smart contracts on test net.


