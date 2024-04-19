//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {ManualToken} from "../src/ManualToken.sol";

contract DeployManualToken is Script{
ManualToken manualToken;

function run( uint256 supply) public returns(ManualToken){
vm.startBroadcast();
manualToken = new ManualToken(supply);
vm.stopBroadcast();

return manualToken;
}

}