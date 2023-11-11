// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console2} from "forge-std/Script.sol";
import {MultiSignatureWallet} from "../src/MultiSignatureWallet.sol";

contract MultiSignatureWalletScript is Script {
    // Define the array of authorized signers and quorum value
    address[] authorizedSigners;
    uint256 quorum = 2; 

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new MultiSignatureWallet(authorizedSigners, quorum);
        vm.stopBroadcast();
    }
}
