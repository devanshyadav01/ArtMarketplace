# GameToken DApp

This project is a decentralized application (DApp) for managing a custom ERC20 token called GameToken. The token is created on the Ethereum blockchain and can be recharged, redeemed, and used to redeem items. The project includes a smart contract written in Solidity, a frontend developed with React, and a deployment script using Hardhat.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Deployment](#deployment)
- [Frontend Setup](#frontend-setup)
- [Usage](#usage)
- [Contract Methods](#contract-methods)
- [Help](#help)
- [Authors](#authors)
- [License](#license)

## Prerequisites

Before you begin, ensure you have met the following requirements:
- Node.js and npm installed
- MetaMask extension installed in your browser
- An Ethereum wallet with test ETH (Rinkeby, Ropsten, or any test network)

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/NICxKMS/ETH_AVX_INTER_MOD_2.git
    cd ETH_AVX_INTER_MOD_2
    ```

2. Install the dependencies:
    ```sh
    npm install
    ```

## Deployment

1. Compile the smart contracts:
    ```sh
    npx hardhat compile
    ```

2. Deploy the smart contract to a local Hardhat network:
    ```sh
    npx hardhat node
    ```

3. In a new terminal, run the deployment script:
    ```sh
    npx hardhat run scripts/deploy.js --network localhost
    ```

4. Note the deployed contract address from the output.

## Frontend Setup

1. Open `pages/index.js` and replace the contract address with the one you noted during deployment:
    ```js
    const contractAddress = "your_deployed_contract_address";
    ```

2. Start the development server:
    ```sh
    npm run dev
    ```

3. Open [http://localhost:3000](http://localhost:3000) in your browser to view the application.

## Usage

1. Connect your MetaMask wallet to the application.
2. Use the provided interface to:
    - Recharge tokens to your account
    - Redeem tokens from your account
    - Redeem items using your tokens

## Contract Methods

### `onlyOwner()`

Modifier to restrict functions to the contract owner.

### `constructor() payable`

Initializes the contract setting the deployer as the owner.

### `getBalance() public view returns(uint256)`

Returns the contract's balance.

### `getTokenName() public view returns(string memory)`

Returns the name of the token.

### `getTokenAbbrv() public view returns(string memory)`

Returns the abbreviation of the token.

### `getTotalSupply() public view returns(uint256)`

Returns the total supply of the token.

### `recharge(address _address, uint256 _amount) public onlyOwner`

Recharges the specified address with the given amount of tokens.

### `redeem(address _address, uint256 _amount) public`

Redeems the specified amount of tokens from the given address.

### `redeemItem(address _address, uint256 _amount, string memory _item) public`

Redeems the specified amount of tokens for an item from the given address.

### `changeOwner(address _newOwner) public onlyOwner`

Changes the owner of the contract to a new address.

## Help

### Common Issues
- **Compilation Errors:** Ensure the Solidity version specified matches the version set in the Remix compiler.
- **Deployment Errors:** Make sure the selected environment is correct and the contract is compiled without errors.
- **Interaction Errors:** Ensure the address and value inputs are valid and that sufficient balance exists for redeeming tokens.

For detailed debugging and assistance, refer to the Remix documentation or community forums.


## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
