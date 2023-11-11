// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {MultiSignatureWallet} from "../src/MultiSignatureWallet.sol";

contract CounterTest is Test {
    MultiSignatureWallet public multiSignatureWallet;

    function setUp() public {
        // multiSignatureWallet = new MultiSignatureWallet();
    }

}
