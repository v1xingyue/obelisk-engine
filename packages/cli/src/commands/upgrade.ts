import type { CommandModule } from "yargs";
import { logError } from "../utils/errors";
import { upgradeHandler } from "../utils";
import { ObeliskConfig, loadConfig } from "@0xobelisk/common";

type Options = {
  network: any;
  configPath: string;
};

const commandModule: CommandModule<Options, Options> = {
  command: "upgrade",

  describe: "Upgrade your move contracts",

  builder(yargs) {
    return yargs.options({
      network: {
        type: "string",
        choices: ["mainnet", "testnet", "devnet", "localnet"],
        desc: "Network of the node (mainnet/testnet/devnet/localnet)",
      },
      configPath: {
        type: "string",
        default: "obelisk.config.ts",
        decs: "Path to the config file",
      },
    });
  },

  async handler({ network, configPath }) {
    try {
      const obeliskConfig = (await loadConfig(configPath)) as ObeliskConfig;

      let schemaNames = Object.keys(obeliskConfig.schemas);

      await upgradeHandler(obeliskConfig.name, network, schemaNames);
    } catch (error: any) {
      logError(error);
      process.exit(1);
    }
    process.exit(0);
  },
};

export default commandModule;
