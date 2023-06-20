// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob allows Alice to spend 10 tokens
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransferMoreThanBalance() public {
        vm.expectRevert();

        uint256 largeAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        ourToken.transfer(alice, largeAmount);
    }

    function testTransferFromMoreThanAllowed() public {
        vm.expectRevert();

        uint256 largeAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        ourToken.approve(alice, STARTING_BALANCE);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, largeAmount);
    }

    function testRevertApproval() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        ourToken.approve(alice, 0);
        assertEq(ourToken.allowance(bob, alice), 0);
    }

    function testApproveAllowance() public {
        uint256 approveAmount = 50 ether;

        vm.prank(bob);
        ourToken.approve(alice, approveAmount);

        assertEq(ourToken.allowance(bob, alice), approveAmount);
    }

    function testChangeAllowance() public {
        uint256 initialAllowance = 50 ether;
        uint256 newAllowance = 30 ether;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        ourToken.approve(alice, newAllowance);

        assertEq(ourToken.allowance(bob, alice), newAllowance);
    }

    function testTransferFromMoreThanAllowance() public {
        vm.expectRevert();

        uint256 approveAmount = 50 ether;
        uint256 transferAmount = 60 ether;

        vm.prank(bob);
        ourToken.approve(alice, approveAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
    }
}
