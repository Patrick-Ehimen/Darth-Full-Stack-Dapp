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
    mapping  (address => mapping (address => uint)) public allowances;
    mapping (address => bool) public blacklist;

    event blacklistUser(address indexed user);
    event unBlacklistUser(address indexed user);
    event IssueToken(address indexed user, uint indexed amount);

    error InsufficentToken();
    error IsBlackListed();

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

    function balanceOf(address _address) external validAddress(_address) override view returns(uint){
        return balances[_address]; 
    }
    function allowance(address _spender, address _owner) external validAddress (_spender) override view returns(uint){
        return allowances[_owner][_spender];
    }
    function approve(address _spender, uint _amount) external validAddress( _spender) override returns(bool){
        allowances[msg.sender][_spender] = _amount;
        return true;
    }
    function transfer(address _to, uint _amount) external validAddress(_to) override returns(bool){
        if(blacklist[_to] == true){
            revert IsBlackListed();
        }
        if(balances[msg.sender] >= _amount){
            revert InsufficentToken();
        }
        balances[_to] += _amount;
        balances[msg.sender] -= _amount;

        return true;
         
    }
    function transferFrom(address _to, address _from, uint _amount) external  validAddress(_to) override returns(bool){
        if(blacklist[_to] == true){
            revert IsBlackListed();
        }
        if(allowances[_from][msg.sender] >= _amount){
            revert InsufficentToken();
        }
        balances[_to] += _amount;
        allowances[_from][msg.sender] -= _amount;
        balances[_from] -= _amount;

        return true;
    }

    function blacklistAddress(address _user) external  validAddress( _user) onlyOwner {
        blacklist[_user] = true;
    }
    
    function unBlacklistAddress(address _user) external validAddress( _user)  onlyOwner {
        blacklist[_user] = false;
    }

    function issue(address _recipient, uint _amount) external validAddress(_recipient) onlyOwner {
        balances[_recipient] += _amount;
        totalSupply += _amount;

        emit IssueToken( _recipient, _amount);

    }
    function redeem(address _recipient, uint _amount) external onlyOwner {
        if(balances[_recipient] < _amount){
            revert InsufficentToken();
        }
        balances[_recipient] -= _amount;
        totalSupply -= _amount;

        emit IssueToken( _recipient, _amount);
    }


}