//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {ManualToken} from "../src/ManualToken.sol";
import {DeployManualToken} from "../script/DeployManualToken.s.sol";

contract ManualTokenTest is Test{

DeployManualToken deployManualToken= new DeployManualToken();
ManualToken manualToken;
address bob;
address alice;
uint256 STARTING_BALANCE=1000 ether;
address owner;

function setUp() public{

bob =  address(0x123);
alice = address(0x456);

manualToken = deployManualToken.run(STARTING_BALANCE);
//It is necessary to look carefully at owner of contract, and fix the issues
//no currency seems to be bestowed to him


owner = manualToken.getOwner();

//Impersonate the owner to mint tokens
vm.startPrank(owner);
manualToken.mintToken(bob, STARTING_BALANCE);
manualToken.mintToken(alice, STARTING_BALANCE);
vm.stopPrank();
}

function testInitialBalance() public view{
    console.log(manualToken.balanceOf(owner));
        uint256 expected = 1000 ether;
        assertEq(manualToken.balanceOf(owner), expected);

    }

function testTransfer() public {
        uint256 amount = 100 ether;
        vm.prank(owner);
        manualToken.transfer(alice, amount);
        assertEq(manualToken.balanceOf(owner), 900 ether);
        assertEq(manualToken.balanceOf(alice), 100 ether+STARTING_BALANCE, "Recipient balance should increase by 100 tokens");
    }

function testApproval() public {

        address spender = alice;
        uint256 amount = 200;
        vm.prank(owner);
        manualToken.approve(spender, amount);
        assertEq(manualToken.allowance(owner, spender), amount);
    }


function testTransferFrom() public {
        uint256 amount = 300 ether;
        vm.prank(bob);
        manualToken.approve(alice, 300 ether);

        vm.prank(alice);
        manualToken.transferFrom(bob, alice, 300 ether);

        assertEq(manualToken.balanceOf(bob), STARTING_BALANCE - amount);
    
        assertEq(manualToken.balanceOf(alice), STARTING_BALANCE + amount, "Recipient balance should increase by 300 tokens");
        assertEq(manualToken.allowance(alice, bob), 0, "Allowance should be reset after transferFrom");
    }

 function testMint() public {
        uint256 amount = 500 ether;
        uint256 prevSupply = manualToken.totalSupply();

        vm.prank(owner);
        manualToken.mintToken(owner, amount);
        assertEq(manualToken.balanceOf(owner), amount+STARTING_BALANCE, "New account should receive 500 tokens");
        assertEq(manualToken.totalSupply(), prevSupply+amount, "Total supply should increase by 500 tokens");
    }

function testBurn() public {
      
        uint256 amount = 200 ether;
        uint256 prevSupply = manualToken.totalSupply();

        vm.prank(bob);
        manualToken.burnToken(bob, amount);
        assertEq(manualToken.balanceOf(bob), 800 ether, "Burned tokens should be deducted from account balance");
        assertEq(manualToken.totalSupply(), prevSupply - 200 ether, "Total supply should decrease by 200 tokens"); 
    }

    function testBurnRevert() public {
      
        uint256 amount = manualToken.balanceOf(alice);
        vm.prank(alice);
        manualToken.approve(bob, amount);
        vm.prank(alice);
        manualToken.burnToken(alice, amount);
        vm.prank(bob);
        vm.expectRevert();
        manualToken.burnToken(alice, amount);
        
    }

  function  testMintTokenRevert() public{
        //prepare
    vm.expectRevert();
    vm.prank(bob);
    manualToken.mintToken(bob, 100 ether);
    }

    function testTransferFromRevertsLackingAllowance() public {
    uint256 amount = 20;
    uint256 amount2=amount-1;
    vm.prank(alice);
    manualToken.approve(bob, amount2); // Set allowance to just below the transfer amount
    vm.expectRevert();
    vm.prank(bob);
    manualToken.transferFrom(alice, owner, amount);
}

    function testTransferFromRevertsWithoutEnoughFunds() public {
    uint256 amount = manualToken.balanceOf(owner);
    vm.startPrank(owner);
    manualToken.approve(alice, amount); 
    manualToken.burnToken(owner, amount-1);
    vm.stopPrank();
    vm.expectRevert();
    vm.prank(alice);
    manualToken.transferFrom(owner, alice, amount);
}


}