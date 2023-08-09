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
npx hardhat run --network polygon scripts_hardhat/1_getPublickeyV6.j
```

