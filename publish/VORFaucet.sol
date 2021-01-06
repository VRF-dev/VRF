pragma solidity 0.6.6;


interface VORTokenInterface {
  function allowance(address owner, address spender) external view returns (uint256 remaining);
  function approve(address spender, uint256 value) external returns (bool success);
  function balanceOf(address owner) external view returns (uint256 balance);
  function decimals() external view returns (uint8 decimalPlaces);
  function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
  function increaseApproval(address spender, uint256 subtractedValue) external;
  function name() external view returns (string memory tokenName);
  function symbol() external view returns (string memory tokenSymbol);
  function totalSupply() external view returns (uint256 totalTokensIssued);
  function transfer(address to, uint256 value) external returns (bool success);
  function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
  function transferFrom(address from, address to, uint256 value) external returns (bool success);
}

/**
 * @title Faucet v2.0.0
 * Faucet smart contract for Avocado Network
 * allows users to receive erc20Basic tokens
 * https://github.com/AvocadoNetwork
 * @author Nicolas Frega - <https://github.com/NFhbar>
 */
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}

contract VORFaucet is Ownable {

    /*
    * Events
    */
    event Deposit(address indexed sender, uint256 value);
    event OneKTokenSent(address receiver);
    event TwoKTokenSent(address receiver);
    event FiveKTokenSent(address receiver);
    event FaucetOn(bool status);
    event FaucetOff(bool status);

    /*
    * Constants
    */
    uint256 constant oneKToken = 1000000000000000000;
    uint256 constant twoKToken = 2000000000000000000;
    uint256 constant fiveKToken = 5000000000000000000;
    uint256 constant oneHours = 1 hours;
    uint256 constant twoHours = 2 hours;
    uint256 constant fiveHours = 5 hours;

    /*
    * Storage
    */
    string public faucetName;
    VORTokenInterface public tokenInstance;
    bool public faucetStatus;
    mapping(address => uint256) status;

    /*
    * Modifiers
    */
    modifier faucetOn() {
        require(faucetStatus);
        _;
    }

    modifier faucetOff() {
        require(!faucetStatus);
        _;
    }

    /*
     * Public functions
     */
    /// @dev Contract constructor
    /// @param _tokenInstance address of ERC20Basic token
    /// @param _faucetName sets the name for the faucet
    constructor(address _tokenInstance, string memory _faucetName)
      public
    {
        tokenInstance = VORTokenInterface(_tokenInstance);
        faucetName = _faucetName;
        faucetStatus = true;

        emit FaucetOn(faucetStatus);
    }

    /// @dev send 1000 Token with a minimum time lock of 1 hour
    function drip1Token()
      public
      faucetOn()
    {
        if(checkStatus(msg.sender)) {
            revert();
        }
        tokenInstance.transfer(msg.sender, oneKToken);
        updateStatus(msg.sender, oneHours);

        emit OneKTokenSent(msg.sender);
    }

    /// @dev send 2000 Token with a minimum time lock of 2 hours
    function drip2Token()
      public
      faucetOn()
    {
        if(checkStatus(msg.sender)) {
            revert();
        }
        tokenInstance.transfer(msg.sender, twoKToken);
        updateStatus(msg.sender, twoHours);

        emit TwoKTokenSent(msg.sender);
    }

    /// @dev send 5000 Token with a minimum time lock of 5 hours
    function drip5Token()
      public
      faucetOn()
    {
        if(checkStatus(msg.sender)) {
            revert();
        }
        tokenInstance.transfer(msg.sender, fiveKToken);
        updateStatus(msg.sender, fiveHours);

        emit FiveKTokenSent(msg.sender);
    }

    /// @dev turn faucet on
    function turnFaucetOn()
      public
      onlyOwner
      faucetOff()
    {
        faucetStatus = true;

        emit FaucetOn(faucetStatus);
    }

    /// @dev turn faucet off
    function turnFaucetOff()
      public
      onlyOwner
      faucetOn()
    {
        faucetStatus = false;

        emit FaucetOff(faucetStatus);
    }

    /*
    * Internal functions
    */
    /// @dev locks and unlocks account based on time range
    /// @param _address of msg.sender
    /// @return bool of current lock status of address
    function checkStatus(address _address)
      internal
      view
      returns (bool)
    {
        //check if first time address is requesting
        if(status[_address] == 0) {
            return false;
        }
        //if not first time check the timeLock
        else {
            // solium-disable-next-line security/no-block-members
            if(block.timestamp >= status[_address]) {
                return false;
            }
            else {
                return true;
            }
        }
    }

    /// @dev updates timeLock for account
    /// @param _address of msg.sender
    /// @param _timelock of sender address
    function updateStatus(address _address, uint256 _timelock)
      internal
    {   // solium-disable-next-line security/no-block-members
        status[_address] = block.timestamp + _timelock;
    }

}