// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract DarthNft is ERC721URIStorage{
    address public owner;
     
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

     constructor()ERC721('DarthNft', 'DTHNFT'){
        owner = msg.sender;
     }
     modifier onlyOwner(){
        require(owner == msg.sender, "You are not the boss");
        _;
     }

     function mintNFT(address _to, string memory _tokenURI) external onlyOwner returns(uint256){
        require(_to != address(0), "Address doesn't exist");
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        return newTokenId;
     }

}