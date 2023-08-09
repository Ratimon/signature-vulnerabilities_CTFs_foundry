// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import "@forge-std/console2.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract ReuseSignature {
	using ECDSA for bytes32;
    address public verifyingAddress = 0x0000000cCC7439F4972897cCd70994123e0921bC;
    mapping(bytes => bool) public used;

	function challenge(
        string calldata message,
        bytes calldata signature
    ) public {
        bytes32 signedMessageHash = keccak256(abi.encode(message))
            .toEthSignedMessageHash();

        // console2.logBytes32(signedMessageHash);
        require(
            signedMessageHash.recover(signature) == verifyingAddress,
            "signature not valid"
        );
        
        require(!used[signature]);
        used[signature] = true;
   }
}