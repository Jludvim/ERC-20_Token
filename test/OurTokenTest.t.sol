//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test{
    OurToken ourToken;
    DeployOurToken deployer;

   address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE=100 ether;

    function setUp() public{

    deployer= new DeployOurToken();
       ourToken= deployer.run();
        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
        //ourToken.transfer(alice, STARTING_BALANCE);
    }

    function testBobBalance() view public{
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public{
        //transferFrom
    uint256 initialAllowance = 1000;

    //Bob approves alice to spend tokens on his behalf    
    vm.prank(bob);
    ourToken.approve(alice, initialAllowance);
    uint256 transferAmount = 500;

    vm.prank(alice);
    ourToken.transferFrom(bob, alice, transferAmount);
    assertEq(ourToken.balanceOf(alice), transferAmount);
    assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

    }

    function testTransfer() public {
    address recipient = address(0x123); // Example recipient address
    uint256 amount = 50;
    vm.prank(msg.sender);
    bool success = ourToken.transfer(recipient, amount);
    assertTrue(success);
    assertEq(ourToken.balanceOf(recipient), amount);
}


function testTransferFrom() public {
    uint256 amount = 1000;
    address receiver = address(0x1);
    vm.prank(msg.sender);
    ourToken.approve(address(this), amount);

 ourToken.transferFrom(msg.sender, receiver, amount);
assertEq(ourToken.balanceOf(receiver), amount);
}


function testTransferFromRevert() public {
    address owner = address(this);
    address spender = address(0x456); // Example spender address
    address recipient = address(0x789); // Example recipient address
    uint256 amount = 20;
    
    vm.prank(msg.sender);
    ourToken.approve(spender, amount - 1); // Set allowance to just below the transfer amount
    vm.expectRevert();
    ourToken.transferFrom(owner, recipient, amount);
}

}