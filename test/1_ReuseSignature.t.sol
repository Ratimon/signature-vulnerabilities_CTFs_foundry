// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";
import {ReuseSignature} from "@main/1_ReuseSignature.sol";

contract ReuseSignatureTest is Test {
    string mnemonic = "test test test test test test test test test test test junk";
    // uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

    // address deployer = vm.addr(deployerPrivateKey);
    address attacker = vm.addr(attackerPrivateKey);

    uint256 polygonFork;
    string POLYGON_RPC_URL = vm.rpcUrl("POLYGON");

    ReuseSignature challange;

    function setUp() public {
        polygonFork = vm.createFork(POLYGON_RPC_URL);
       
        challange = ReuseSignature(0xa94a3AB66FaBc6e9F672924a76587c16322752E9);
    }

    function testFork_isSolved() public {
        vm.startPrank(attacker);
        vm.selectFork(polygonFork);
         // block at 42370728
        vm.rollFork(42370800);


        vm.stopPrank();
    }

}