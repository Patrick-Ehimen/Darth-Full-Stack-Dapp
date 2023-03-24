// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Darth_ERC20Token.sol";
import "./Darth_NFT.sol";

contract NFT_Staking is Darth_NFT, Darth_ERC20Token {
    bool public active;
    uint256 public startTime;
    uint256 public cutoffTime;

    struct rewardSchedule {
        uint64 days30;
        uint64 days45;
        uint64 days60;
        uint64 days90;
    }
}
