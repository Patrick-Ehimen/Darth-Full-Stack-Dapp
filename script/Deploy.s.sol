// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Darth_ERC20Token.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new Darth();
    }
}
