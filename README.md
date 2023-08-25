## Install the dependency with specific version

```
forge install openzeppelin/openzeppelin-contracts@v4.9.3
```

## Integrating Hardhat

1. 

```
pnpm add -D hardhat	
```
2. 

```
npx hardhat
```
3. Add this to your `hardhat.config.ts` file

```ts
import fs from "fs";
import "hardhat-preprocessor";
```
4. Ensure the following function is present

```ts
function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}
```

5. Add the following to your exported HardhatUserConfig object:

```ts
preprocess: {
  eachLine: (hre) => ({
    transform: (line: string) => {
      if (line.match(/^\s*import /i)) {
        for (const [from, to] of getRemappings()) {
          if (line.includes(from)) {
            line = line.replace(from, to);
            break;
          }
        }
      }
      return line;
    },
  }),
},
paths: {
  sources: "./src",
  cache: "./cache_hardhat",
},
```
## Integrating Python

```sh
poetry new scripts_python`
```

## Running Scripts
```sh
npx hardhat run --network polygon scripts_hardhat/2_getPublickeyV6.j
```

```sh
cd scripts_python
poetry run python scripts_python/2_craftMessageAndSig.py
```


## Domain Separator

1. name: the dApp or protocol name

2. version: The current version of what the standard calls a “signing domain”. It prevents signatures from one dApp version from working with those of others.

3. chainId: The EIP-155 chain id. Prevents a signature meant for one network from working on another, such as the mainnet.

4. verifyingContract: The Ethereum address of the contract that will verify the resulting signature.

5. salt: A unique 32-byte value hardcoded into both the contract and the dApp meant as a last-resort means to distinguish the dApp from others.