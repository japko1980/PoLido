import { BigNumber } from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";

// In the future, select from different deployment details file based on the --network argument
// For now it is hardcoded to use only Goerli
import * as GOERLI_DEPLOYMENT_DETAILS from "../deploy-goerli.json";
import { GoerliOverrides, TokenAddresses } from "./constants";
import { attachContract } from "./utils";

const verifyContract = async (
    hre: HardhatRuntimeEnvironment,
    contractAddress: string
) => {
    await hre.run("verify:verify", {
        address: contractAddress
    });
};

export const verify = async (hre: HardhatRuntimeEnvironment) => {
    const contracts = [
        GOERLI_DEPLOYMENT_DETAILS.lido_matic_implementation,
        GOERLI_DEPLOYMENT_DETAILS.node_operator_registry_implementation,
        GOERLI_DEPLOYMENT_DETAILS.validator_factory_implementation
    ];

    for (const contract of contracts) {
        await verifyContract(hre, contract);
    }
};

export const addOperator = async (
    hre: HardhatRuntimeEnvironment,
    name: string,
    rewardAddress: string,
    pubKey: Uint8Array | string,
    privateKey?: string
) => {
    const nodeOperatorRegistryAddress =
        GOERLI_DEPLOYMENT_DETAILS.node_operator_registry_proxy;

    const nodeOperatorRegistry = await attachContract(hre, nodeOperatorRegistryAddress, "NodeOperatorRegistry");

    await (
        await nodeOperatorRegistry.addOperator(name, rewardAddress, pubKey, GoerliOverrides)
    ).wait();
};

export const removeOperator = async (
    hre: HardhatRuntimeEnvironment,
    id: string,
    privateKey?: string
) => {
    const nodeOperatorRegistryAddress =
        GOERLI_DEPLOYMENT_DETAILS.node_operator_registry_proxy;

    const nodeOperatorRegistry = await attachContract(hre, nodeOperatorRegistryAddress, "NodeOperatorRegistry");

    await (await nodeOperatorRegistry.removeOperator(id, GoerliOverrides)).wait();
};

export const stakeValidator = async (
    hre: HardhatRuntimeEnvironment,
    amount: BigNumber,
    heimdallFee: BigNumber,
    privateKey?: string
) => {
    const nodeOperatorRegistryAddress =
        GOERLI_DEPLOYMENT_DETAILS.node_operator_registry_proxy;

    const token = await attachContract(hre, TokenAddresses.Testv4, "ERC20", privateKey);
    const nodeOperatorRegistry = await attachContract(hre, nodeOperatorRegistryAddress, "NodeOperatorRegistry", privateKey);
    const operator = await nodeOperatorRegistry.getNodeOperator(1, false);

    await token.approve(operator[6], amount.add(heimdallFee));
    await (await nodeOperatorRegistry.stake(amount, heimdallFee)).wait();
};