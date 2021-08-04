pragma solidity >=0.4.22 <0.9.0;


contract DNextTokenWhitelist {
	address owner;
	mapping(bytes32 => bool) whitelist; // 
	constructor() public {
		owner = msg.sender;
	}

	function register() external {

	whitelist[keccak256(msg.sender)] = true;
	}
	
	function unregister() external{

	whitelist[keccak256(msg.sender)] = false;	
	
	}

	function isRegistered(address anAddress) public view returns (bool registered) {
		return whitelist[keccak256(anAddress)];
	}

}
