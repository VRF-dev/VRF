pragma solidity 0.6.6;

import "../VRFConsumerBase.sol";

contract RandomNumberConsumer is VRFConsumerBase {
    
    bytes32 internal keyHash;
    uint256 internal fee;
    
    uint256 public randomResult;
    
    /**
     * Constructor inherits VRFConsumerBase
     * 
     * Network: Kovan
     * VRF Coordinator address:           0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * VOR token address:                 0x01be23585060835e02b77ef475b0cc51aa1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
     */
    constructor() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01be23585060835e02b77ef475b0cc51aa1e0709  // VOR Token
        ) public
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 VOR
    }
    
    /** 
     * Requests randomness from a user-provided seed
     */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(VOR.balanceOf(address(this)) >= fee, "Not enough VOR - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }
}