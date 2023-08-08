const { ethers } = require("hardhat");

// Ran this with polygon as the hardhat network
// Which will get the public key that signed the transaction with hash 0xa2b0dbab8a435b11de83bbbc6dffb7661d6ffc7980d7c5d6f911dab2afc35812

async function getSenderPublicKey(transactionHash) {
    // Fetch the transaction details
    const transaction = await ethers.provider.getTransaction(transactionHash);

    console.log("Transactio", transaction);

    const expandedSig = {
        r: transaction.signature.r,
        s: transaction.signature.s,
        v: transaction.signature.v,
    };

    const signature = ethers.Signature.from(expandedSig).serialized;
    console.log("signature", signature);

    const raw = ethers.Transaction.from(transaction).unsignedSerialized;
    console.log("raw", raw);

    const msgHash = ethers.keccak256(raw); // as specified by ECDSA
    console.log("msgHash", msgHash);
    const msgBytes = ethers.getBytes(msgHash); // create binary hash

    console.log("msgBytes", msgBytes);

    const publicKey = ethers.SigningKey.recoverPublicKey(msgBytes, signature);
    console.log("publicKey", publicKey);

    const address = ethers.recoverAddress(msgBytes, signature);
    const actualAddress = transaction.from;

    console.log("address", address);
    console.log("actualAddress", actualAddress);

    if (actualAddress !== address) {
        throw new Error("Failed to recover the public key");
    }

    return publicKey;
}

(async () => {
    const transactionHash = "0xf25e29a951681c6dc49db7697ba3cafe0574c131e919966519a5ba11293c33ec";
    const publicKey = await getSenderPublicKey(transactionHash);
    console.log("Sender Public Key:", publicKey);
})();