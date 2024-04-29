## ERC-20 Token

**this is a project developed exploring the ERC-20 protocol. It features two main contracts. a ManualToken.sol, and OurToken.sol**

**OurToken** is a token developed using the OpenZeppelin library, and following the general Guideline of
Patrick Collins course.
**ManualToken** is a contract manually and personally developed using the description set for the required functions in the official documentation for ERC.
It does add some small, extra functionality over it. 

**None of the code here presented has (as of yet) been audited, and is hence unsuited for actual deployment**

### QuickStart

1. Clone the repository:
  ```git clone https://github.com/Jludvim/ERC-20_Token.git```
3. Navigate to the project directory: ```cd ERC-20_Token```
4. Deploy the contract
  ``` forge script script/DeployManualToken:DeployManualToken --rpc-url (Your_RPC_URL) --private-key (Do not Use plain text!) --broadcast --verify --etherscan-api-key (your_api_key)```
(Or change DeployManualToken to DeployOurToken)

### Layout
It does feature the two main files, **ManualToken.sol** and **OurToken.sol**, bot of which are functionally independent. To each do also correspond a script file used for deployment, and a test file (named after the main contracts respectively). 

### requirement
Solidity 0.8.18 or higher
An ubuntu terminal (or WSL for windows) to execute the related commands
A blockchain address, regardless of the network
Getting tokens from a faucet, or keeping some in the wallet

### License
This project is licensed under the MIT License

### Contact
You can write at the following email: jeremiaspini7@gmail.com

