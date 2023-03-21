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


contract DarthNft is ERC721URIStorage{
    address public owner;
    mapping (address => bool) isWhitelisted;
    mapping (address => uint256) usersNft;
    enum State {NOTSTARTED, STARTED, STOPPED}
    State public presaleState;
    uint256 public expectedNftMinted;
    uint256 public totalNFTMinted;
     
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

     constructor()ERC721('DarthNft', 'DTHNFT'){
        owner = msg.sender;
        presaleState = State.NOTSTARTED;
        expectedNftMinted = 200;
        totalNFTMinted = 0;
     }
     modifier onlyOwner(){
        require(owner == msg.sender, "You are not the boss");
        _;
     }

     function mintNFT(address _to, string memory _tokenURI) external returns(uint256){
        require(_to != address(0), "Address doesn't exist");
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        
        return newTokenId;
     }

     function setState (State _state) public onlyOwner {
        presaleState = _state;
     }

    function changeExpectedNftMinted (uint256 _value) public onlyOwner {
        expectedNftMinted += _value;
    }

}