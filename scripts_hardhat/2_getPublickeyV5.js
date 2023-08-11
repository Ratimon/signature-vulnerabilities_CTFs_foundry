const { ethers } = require("ethers-legacy");
const dotenv = require('dotenv')

// Ran this with polygon as the hardhat network
// Which will get the public key that signed the transaction with hash 0xf25e29a951681c6dc49db7697ba3cafe0574c131e919966519a5ba11293c33ec

async function getSenderPublicKey(transactionHash) {
    // Fetch the transaction details

    console.log("ethers", ethers);
    console.log("ethers.version", ethers.version);

    const provider = new ethers.providers.JsonRpcProvider(`${process.env.POLYGON_RPC_URL}`);

    const transaction = await provider.getTransaction(transactionHash);

    const expandedSig = {
        r: transaction.r,
        s: transaction.s,
        v: transaction.v,
    };

    const signature = ethers.utils.joinSignature(expandedSig);

    console.log("signature", signature);

    const transactionData = {
        gasLimit: transaction.gasLimit,
        value: transaction.value,
        nonce: transaction.nonce,
        data: transaction.data,
        chainId: transaction.chainId,
        to: transaction.to, // you might need to include this if it's a regular transaction and not simply a contract deployment
        type: transaction.type,
        maxFeePerGas: transaction.maxFeePerGas,
        maxPriorityFeePerGas: transaction.maxPriorityFeePerGas,
    };

    const rstransaction = await ethers.utils.resolveProperties(transactionData);
    console.log("rstransaction", rstransaction);
    const raw = ethers.utils.serializeTransaction(rstransaction); // returns RLP encoded transaction
    console.log("raw", raw);
    const msgHash = ethers.utils.keccak256(raw); // as specified by ECDSA
    console.log("msgHash", msgHash);
    const msgBytes = ethers.utils.arrayify(msgHash); // create binary hash

    const publicKey = ethers.utils.recoverPublicKey(msgBytes, signature);
    const address = ethers.utils.recoverAddress(msgBytes, signature);
    const actualAddress = transaction.from;

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