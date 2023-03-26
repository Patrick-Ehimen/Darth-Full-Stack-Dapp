// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract DarthStaking {
    IERC721 public nft;
    IERC20 public rewardToken;
    uint256 public rewardAmount;
    uint256 public minStakingPeriod = 2 days;

    struct Stake {
        uint256 nftTokenId;
        uint startTime;
    }

    Stake public stakes;

    mapping(address => Stake) public stakedNFTs;
    //mapping(address => Stake) public userStake;

    event Staked(address indexed staker, uint nftId);
    event Unstaked(address indexed staker, uint nftId);

    constructor(address _nft, address _rewardToken, uint256 _rewardAmount) {
        nft = IERC721(_nft);
        rewardToken = IERC20(_rewardToken);
        rewardAmount = _rewardAmount;
    }

    function stake(uint256 _tokenId) external {
        require(
            nft.ownerOf(_tokenId) == msg.sender,
            "Must be owner of NFT to stake"
        );
        nft.transferFrom(msg.sender, address(this), _tokenId);
        stakedNFTs[msg.sender] = Stake(_tokenId, block.timestamp);

        emit Staked(msg.sender, _tokenId);
    }

    function unStake() external {
        Stake memory userStake = stakedNFTs[msg.sender];
        require(userStake.nftTokenId != 0, "No NFT staked");
        require(
            block.timestamp >= userStake.startTime + minStakingPeriod,
            "Minimum staking period not met"
        );
        nft.transferFrom(address(this), msg.sender, userStake.nftTokenId);
        uint256 reward = calculateReward(userStake.startTime);
        rewardToken.transfer(msg.sender, reward);

        delete stakedNFTs[msg.sender];

        emit Unstaked(msg.sender, userStake.nftTokenId);
    }

    function calculateReward(
        uint256 _startTime
    ) internal view returns (uint256) {
        uint256 timeStaked = block.timestamp - _startTime;
        return (timeStaked * rewardAmount) / 1 days;
    }
}
