# Automated Lottery

## Overview

The Automated Lottery project is a decentralized raffle system built on Ethereum. It allows users to participate in a lottery by sending Ether, and a winner is selected randomly using Chainlink VRF (Verifiable Random Function). The project is implemented in Solidity and uses Foundry for testing and deployment.

---

## Table of Contents

- Overview
- Table of Contents
- Features
- Technologies Used
- Project Structure
- Installation
- Usage
  - Deployment
  - Testing
- Key Contracts
- Events
- Security Considerations
- License
- Acknowledgments

---

## Features

- **Decentralized Raffle:** Users can enter the raffle by sending a minimum amount of Ether.
- **Random Winner Selection:** The winner is selected using Chainlink VRF for provable randomness.
- **Automated Upkeep:** The contract uses Chainlink Keepers to automate the process of checking and performing upkeep.
- **Secure and Transparent:** Implements best practices like the Checks-Effects-Interactions (CEI) pattern and emits events for transparency.

---

## Technologies Used

- **Solidity:** Smart contract programming language.
- **Foundry:** A blazing-fast, portable, and modular toolkit for Ethereum application development.
- **Chainlink VRF:** For generating verifiable random numbers.
- **Chainlink Keepers:** For automating contract upkeep.

---

## Installation

**1. Clone the repository:**
```bash
git clone https://github.com/your-username/foundry-lottery.git
cd foundry-lottery
```

**2. Install Foundry:**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

**3. Install dependencies:**
```bash
make install
```

---

## Usage

**Deployment**

1. Configure the deployment parameters in `HelperConfig.s.sol`.

2. Encrypt your Private Key in a keystore:
   ```bash
   cast wallet import <your-account-name> --interactive
   ```
   follow the prompts and voila! 

3. Set Up Environment Variables: Create a .env file in the root directory and add the following:
   ```bash
   SEPOLIA_RPC_URL=<your-sepolia-rpc-url>
   ETHERSCAN_API_KEY=<your-etherscan-api-key>
   ACCOUNT=<your-account-name> # account of your encrypted private keystore
   ```

4. Deploy the contract:
   - To a local network (ANVIL):
     ```bash
     forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url http://127.0.0.1:8545 --account <your-account-name> --broadcast
     ```
  
  - To sepolia:
    ```bash
    make deploy-sepolia
    ```

  Note: you can also deploy it to any chain supported by chainlink, just set your configurations in `HelperConfig.s.sol`
    
**Testing**
- Run all test:
  ```bash
  forge test
  ```
- Run unit tests:
  ```bash
  forge test --match-path test/unit/RaffleTest.t.sol
  ```
- Run integration tests:
  ```bash
  forge test --match-path test/integration/Interactions.t.sol
  ```

---

## Key Contracts

**`Raffle.sol`**

The `Raffle` contract implements the core functionality of the lottery system. Key features include:

`enterRaffle()`: Allows users to enter the raffle by sending Ether.
`checkUpkeep()`: Checks if the conditions for selecting a winner are met.
`performUpkeep()`: Triggers the process of selecting a winner.
`fulfillRandomWords()`: Callback function for Chainlink VRF to handle the random number and select a winner.

**`HelperConfig.s.sol`**

This script provides configuration for deploying the contract on different networks, including local and test networks. It dynamically adjusts the configuration based on the chain ID.

**`Interactions.s.sol`**

This script contains helper functions for interacting with Chainlink services, such as creating and funding subscriptions and adding consumers.

---

## Testing

The project includes both unit and integration tests:

- **Unit Tests:** Focus on individual functions of the `Raffle` contract.
- **Integration Tests:** Simulate the entire raffle flow, including interactions with Chainlink VRF and Keepers.

---

## Events

The `Raffle` contract emits the following events:

- **`RaffleEntered(address indexed player)`:** Emitted when a user enters the raffle.
- **`RequestRaffleWinner(uint256 indexed requestId)`:** Emitted when a random number request is made.
- **`WinnerPicked(address indexed winner)`:** Emitted when a winner is selected.

---

## Security Considerations

- **Reentrancy Protection:** The contract follows the CEI pattern to prevent reentrancy attacks.
- **Randomness Verification:** Uses Chainlink VRF to ensure the randomness is verifiable and tamper-proof.
- **Access Control:** Only authorized entities can trigger upkeep.

---

## License

This project is licensed under the MIT License.

---

## Acknowledgments

- [Chainlink](https://chain.link/) for providing VRF and Keepers.
- [Foundry](https://book.getfoundry.sh/) for the development and testing framework.
- [Cyfrin](https://updraft.cyfrin.io/) for the foundry devops dependency and the whole project in general 😄

---

## Contributions

Contributions to the **Lottery** project are welcome and encouraged! Whether it's fixing bugs, adding new features, improving documentation, or writing tests, your help is greatly appreciated.