// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MultiSignatureWallet} from "../src/MultiSignatureWallet.sol";

contract CounterTest is Test {
    MultiSignatureWallet public multiSignatureWallet;
    address[] authorizedSigners;
    uint256 quorum = 2; 


    function setUp() public {
        multiSignatureWallet = new MultiSignatureWallet(authorizedSigners, quorum);
    }

    function testIfOwnerIsTheOneWhoDeploy() public{
        vm.prank(address(0));
        // console.log(multiSignatureWallet.balance);
    }

}
