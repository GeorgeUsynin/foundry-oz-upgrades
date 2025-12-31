// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";

import {ContractA} from "../src/ContractA.sol";
import {ContractB} from "../src/ContractB.sol";
import {Options, Upgrades} from "@openzeppelin-foundry-upgrades/Upgrades.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract UpgradesScript is Script {
    function run() public {
        address admin = vm.envAddress("PROXY_ADMIN");
        vm.startBroadcast();

        // Deploy `ContractA` as a transparent proxy using the Upgrades Plugin
        address transparentProxy =
            Upgrades.deployTransparentProxy("ContractA.sol", admin, abi.encodeCall(ContractA.initialize, 10));

        vm.stopBroadcast();
    }
}

contract UpgradesToScript is Script {
    function run() public {
        // Specifying the address of the existing transparent proxy
        address mostRecentTransparentProxy =
            DevOpsTools.get_most_recent_deployment("TransparentUpgradeableProxy", block.chainid);

        // Setting options for validating the upgrade
        Options memory opts;
        opts.referenceContract = "ContractA.sol";

        // Validating the compatibility of the upgrade
        Upgrades.validateUpgrade("ContractB.sol", opts);

        vm.startBroadcast();
        // Upgrading to ContractB and attempting to increase the value
        Upgrades.upgradeProxy(mostRecentTransparentProxy, "ContractB.sol", abi.encodeCall(ContractB.increaseValue, ()));
        vm.stopBroadcast();
    }
}

