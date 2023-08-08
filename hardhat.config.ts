import { HardhatUserConfig } from "hardhat/config";
import 'dotenv/config';
import fs from "fs";
import "hardhat-preprocessor"
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    compilers: 
  [
    {
      version: "0.8.19",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        outputSelection: {
          "*": {
              "*": ["storageLayout"],
          },
        },
      }
    }
  ]
  },

  networks: {
    polygon: {
      url: `${process.env.POLYGON_RPC_URL}`,
      accounts: [`${process.env.PRIVATE_KEY}`]
    }
  },

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
      }
    }),
  },
  paths: {
    sources: "./src",
    cache: "./cache_hardhat",
  },
  typechain: {
    outDir: 'typechain',
    target: 'ethers-v5',
  },

};

function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean) // remove empty lines
    .map((line) => line.trim().split("="));
}


export default config;
