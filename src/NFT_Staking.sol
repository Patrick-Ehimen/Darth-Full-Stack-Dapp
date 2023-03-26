// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract DarthStaking {
    IERC721 public nft;
    IERC20 public rewardToken;
    uint256 public rewardAmount;

    mapping(address => uint256) public stakedNFTs;

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
        stakedNFTs[msg.sender] = _tokenId;
        rewardToken.transfer(msg.sender, rewardAmount);
        emit Staked(msg.sender, _tokenId);
    }

    function unstake() external {
        uint256 tokenId = stakedNFTs[msg.sender];
        require(tokenId != 0, "No NFT staked");
        nft.transferFrom(address(this), msg.sender, tokenId);
        stakedNFTs[msg.sender] = 0;
        emit Unstaked(msg.sender, tokenId);
    }
}
