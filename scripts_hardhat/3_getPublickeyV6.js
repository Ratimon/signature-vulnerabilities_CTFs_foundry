const { ethers } = require("hardhat");

// Ran this with polygon as the hardhat network
// Which will get the public key that signed the transaction with hash 0xf25e29a951681c6dc49db7697ba3cafe0574c131e919966519a5ba11293c33ec

async function getSenderPublicKey(transactionHash) {
    // Fetch the transaction details
    const transaction = await ethers.provider.getTransaction(transactionHash);

    console.log("Transaction", transaction);

    const expandedSig = {
        r: transaction.signature.r,
        s: transaction.signature.s,
        v: transaction.signature.v,
    };

    const signature = ethers.Signature.from(expandedSig).serialized;
    console.log("signature", signature);

    const raw = ethers.Transaction.from(transaction).unsignedSerialized;
    console.log("raw", raw);
    // console.log("raw as hex", raw .toString('hex'));

    const msgHash = ethers.keccak256(raw); // as specified by ECDSA
    console.log("msgHash", msgHash);
    const msgBytes = ethers.getBytes(msgHash); // create binary hash

    console.log("msgBytes", msgBytes);
    // console.log("a hash of the unsigned tx",msgHash.toString('hex'));

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
// https://polygonscan.com/tx/0x09281ab72c20092dc9b414745ef2673116e36dfe069b61d2e37ecb8815b140bf
(async () => {
    const transactionHash = "0x09281ab72c20092dc9b414745ef2673116e36dfe069b61d2e37ecb8815b140bf";
    const publicKey = await getSenderPublicKey(transactionHash);
    console.log("Sender Public Key:", publicKey);
})();