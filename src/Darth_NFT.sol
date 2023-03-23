// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// create a whitelist of address (mapping)
// create those who have bought the nft (either presale or after lauch)
// create status if the presale
// expected nft to mint is 200
// price of the nft is 0.01 ether
// if user is whitelisted price will drop to 0.005 ether

contract DarthNft is ERC721URIStorage {
    address public owner;
    mapping(address => bool) isWhitelisted;
    mapping(address => uint256) usersNft;
    enum State {
        NOTSTARTED,
        STARTED,
        STOPPED
    }
    State public presaleState;
    uint256 public expectedNftMinted;
    uint256 public totalNFTMinted;
    uint256 public nftPrice;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("DarthNft", "DART") {
        owner = msg.sender;
        expectedNftMinted = 2000;
        totalNFTMinted = 0;
        nftPrice = 0.1 ether;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the boss");
        _;
    }

    function mintNFT(
        address _to,
        string memory _tokenURI
    ) external payable returns (uint256) {
        require(_to != address(0), "Address doesn't exist");
        require(totalNFTMinted <= expectedNftMinted, "Oops!! can't mint NFT");

        uint256 newTokenId;

        if (isWhitelisted[msg.sender]) {
            require(
                presaleState == State.STARTED,
                "The presale has not started"
            );
            // require(usersNft[msg.sender] <= 2, "You can't mint more that 2 times");
            require(
                msg.value == nftPrice / 2,
                "Ether value sent is not correct"
            );

            _tokenIds.increment();
            newTokenId = _tokenIds.current();
            _mint(_to, newTokenId);
            _setTokenURI(newTokenId, _tokenURI);
            totalNFTMinted++;
            usersNft[msg.sender]++;
        }

        require(msg.value == nftPrice, "Ether value sent is not correct");
        _tokenIds.increment();
        newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        return newTokenId;
    }

    function ownerETHBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function addWhitelist(address _user) external onlyOwner {
        require(_user != address(0), "Address doesn't exist");
        isWhitelisted[msg.sender] = true;
    }

    function setState(State _state) external onlyOwner {
        presaleState = _state;
    }

    // Add the value to the expected value of NFTs minted. This function is called
    // when a user purchases an NFT from the marketplace.

    function changeExpectedNftMinted(uint256 _value) external onlyOwner {
        expectedNftMinted += _value;
    }

    // This function changes the price of the NFTs the presale
    // It can only be called by the owner of the contract
    // It can only be called if the presale hasn't started yet
    function changePrice(uint256 _price) external onlyOwner {
        require(
            presaleState != State.STARTED,
            "Boss you can't change price once the presale has started"
        );
        nftPrice = _price;
    }
}
