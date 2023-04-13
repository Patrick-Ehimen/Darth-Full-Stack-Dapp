// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DarthStablecoin is IERC20{
    // must have a owner, 
    // must have a total supply
    // must have a name and decimal
    // see balance, transfer, approve, transfer from, allowance
    // blacklist and unblacklist an address
    // redeem and issue token for balance

    address public owner;
    uint public override totalSupply;
    string public name;
    uint public decimals;
    mapping(address => uint) public balances;
    mapping  (address => uint) public allowances;
    mapping (address => bool) public blacklist;

    event blacklistUser(address indexed user);
    event unBlacklistUser(address indexed user);

    constructor(uint _supply, uint _decimals, string memory _name){
        owner = msg.sender;
        totalSupply = _supply;
        decimals = _decimals;
        name = _name;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier validAddress(address _address){
        require(_address != address(0));
        _;
    }

    function balanceOf(address _address) external validAddress(_address) override view returns(uint){}
    function allowance(address _spender, address _owner) external validAddress (_spender) override view returns(uint){}
    function approve(address _spender, uint _amount) external validAddress( _spender) override returns(bool){}
    function transfer(address _to, uint _amount) external validAddress(_to) override returns(bool){}
    function transferFrom(address _to, address _from, uint _amount) external  validAddress(_to) override returns(bool){}

    function blacklistAddress(address _user) external  validAddress( _user) onlyOwner {}
    
    function unBlacklistAddress(address _user) external validAddress( _user)  onlyOwner {}

    function issue() external onlyOwner {}
    function redeem() external onlyOwner {}


    

}