//SPDX-License-Identifer: MIT

/**
 * @title ManualToken
 * @author Jeremias Pini
 * @notice A contract that implements the ERC-20 standard, for which functionalities
 * were manually developed. It follows the required implementations, with few additions
 */

pragma solidity ^0.8.18;

contract ManualToken {

/*errors */

error NotEnoughFunds();
error NoPermissions();
error OnlyOwner();

//State variables
/**
 * @dev 
 * a mapping for balance storage, a nested mapping for approved allowances
 */
mapping(address=>uint256) private s_balance;
mapping(address spender => mapping(address owner => uint256 allowance)) private s_approved;
uint256 private s_totalSupply;
address private s_owner;

//ERC20
event Transfer(address indexed _from, address indexed _to, uint256 _value);
event Approval(address indexed _owner, address indexed _spender, uint256 _value);


//functions


constructor(uint256 MintVal){
    mint(msg.sender, MintVal);
    s_owner=msg.sender;
}


 //ERC20 needed implementations
    function totalSupply() public view returns (uint256){
        return s_totalSupply; 
    }


    //returns balance of an address
    function balanceOf(address _owner) public view returns (uint256 balance){
        return s_balance[_owner];
    }

    //
    function transfer(address _to, uint256 _value) public returns (bool success){
        if(s_balance[msg.sender]<_value){
            revert NotEnoughFunds();
        }
        uint256 previousBalances = balanceOf(msg.sender)+balanceOf(_to);
        s_balance[_to]+=_value;
        s_balance[msg.sender]-=_value;
        require(balanceOf(msg.sender)+balanceOf(_to) == previousBalances);
        success=true;
        
        emit Transfer(msg.sender, _to, _value);
        return success;
    }


    function approve(address _spender, uint256 _value) public returns (bool success){
        s_approved[msg.sender][_spender] = _value;
        success= allowance(msg.sender, _spender) == _value;
        emit Approval(msg.sender, _spender, _value);
        return success;
    }


    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return s_approved[_owner][_spender];
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        if(_value > allowance(_from, msg.sender)){
            revert NoPermissions();
        }
         if( balanceOf(_from) < _value ){
          revert NotEnoughFunds();
        }
        uint256 previousBalances=balanceOf(_from)+balanceOf(_to);
        s_balance[_to] += _value;
        s_balance[_from] -= _value;
        require(balanceOf(_from) + balanceOf(_to) == previousBalances);

        //approves new allowance = previous_allowance - value
        s_approved[_from][msg.sender] = allowance(_from, msg.sender) - _value;

        success=true;
        emit Transfer(_from, _to,  _value);
        return success;
    }

    

 //Extra functions
    function name() public pure returns(string memory){
    return "AToken";
    }
    
    
    function symbol() public pure returns (string memory){
        return "ATOK"; /*a token*/
    }

    /**
     * same decimals as those that relate Eth and Wei
     * Irrelevant for contract logic, useful for client
     */    
    function decimals() public pure returns (uint8){
        return 18;
    }

    /**
     * Mint function, mints a set amount of tokens to
     *  the specified account
     */
function mint(address account, uint256 amount) private{
        require(account != address(0));

        s_totalSupply += amount;
        s_balance[account] = s_balance[account]+amount;
        emit Transfer(address(0), account, amount);
    }
    

    /**
     * Burn function, works for any account
     *  but is constrained by either owning the account
     * or having the required allowance
     */
function burn(address account, uint256 amount) private {
    require(account != address(0));

   if(balanceOf(account) < amount)
   {
    revert NotEnoughFunds();
   }
  
    s_totalSupply-=amount;
    s_balance[account] -= amount;
    emit Transfer(account, address(0), amount);
}


/**
 * Though the burns and mint could 
 * have possibly been implemented in a single function
 * this seems to make things modular, safer and easier
 */
function burnToken(address account, uint256 amount) external{
 if(account != msg.sender){
        if(
            allowance(account, msg.sender) < amount
        ) {
            revert NoPermissions();
        }
    }
    burn(account, amount);
}


function mintToken(address account, uint256 amount) external onlyOwner{
    mint(account, amount);
}


function getOwner() public view returns(address){
    return s_owner;
}



//Modifier, limits execution to contract owner
modifier onlyOwner(){
    if(getOwner()!=msg.sender) revert OnlyOwner();
    _;
}

}