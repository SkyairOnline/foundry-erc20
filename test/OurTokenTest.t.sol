// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public otToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        otToken = deployer.run();

        vm.prank(msg.sender);
        otToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(otToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approve Alice to spend tokens on her behalf
        vm.prank(bob);
        otToken.approve(alice, initialAllowance);

        uint256 transferredAmount = 500;

        vm.prank(alice);
        otToken.transferFrom(bob, alice, transferredAmount);

        assertEq(otToken.balanceOf(alice), transferredAmount);
        assertEq(otToken.balanceOf(bob), STARTING_BALANCE - transferredAmount);
    }
}