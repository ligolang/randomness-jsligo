## Contract randomness

This smart contract implements an on-chain random number generator. The number generation is based on a random seed and a pseudo-random generator algorithm. In order to have an unbiased seed, users must perform a "Commit & Reveal" mechanism which is perfomed into two separated phases.

First users choose a secret number and send a proof  to the contract. Once all proofs are received users can reveal their secret numbers (and verify the committed proof). In the end all secret numbers are gathered and used to compute a hash (merckle tree), this hash is the random seed and can be converted into a nat. 

A Mercenne twister algorithm can be applied in order to generate random number with a satisfying distribution.
A modulus can be applied on the generated number to provide a random number on a specific range.

This smart contract intends to demonstrate the random number generation. The (`min`, `max`) range is specified in the storage at origination, and the result is stored in the `result_nat` field of the storage.

### Compilation of randomness contract

This repository provides a Makefile for compiling and testing smart contracts. One can type `make` to display all available rules. 
The `make all` command will delete the compiled smart contract, then compile the smart contract and then launch tests.

A makefile is provided to compile the "Randomness" smart contract, and to launch tests.
```
cd src/cameligo/
make compile
make test
```

### Tests

A makefile is provided to launch tests.
```
cd src/cameligo/
make test
```

### Deployment

A typescript script for deployment is provided to originate the smart contrat. This deployment script relies on .env file which provides the RPC node url and the deployer public and private key.

```
cd src/cameligo
make deploy
```
