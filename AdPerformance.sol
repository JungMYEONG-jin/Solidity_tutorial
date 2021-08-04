// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;



import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract AdPerformance is usingOraclize {

  address owner; // 소유자 주소
  address beneficiary; // 보상 지급 주소
  uint gweiToPay; // 1회당 지급 금액
  string youtubeId; //youtube id
  bool withdrawn; // 정산여부


  constructor(address _b, uint _gwei, string _id) public payable {
   	
	owner = msg.sender;
	beneficiary = _b;
	gweiToPay = _gwei;
	youtubeId = _id;
	withdrawn = false;
  }




   function withdraw() public {
        require(msg.sender == beneficiary);
        require(!withdrawn);
        
        string memory query = strConcat('json(https://www.googleapis.com/youtube/v3/videos?id=',
                youtubeId,
                '&key=AIzaSyAhV6cw7pjvrrBoSkIDxff4gvovbF_9rXk%20&part=statistics).items.0.statistics.viewCount');
        oraclize_query('URL', query);
    }  





  function __callback(bytes32, string result) public{
 	require(msg.sender == oraclize_cbAddress());
	require(!withdrawn);
	
	uint viewCount = stringToUint(result);
	uint amount = viewCount*gweiToPay;*10000000000;
	uint balance = address(this).balance;
	
	if(balance<amount){
		amount = balance;
}

	beneficiary.transfer(amount);
	withdrawn = true;


}
  function isWithdrawn() public view returns (bool){
	return withdrawn;
}


  function refund() public{
	require(msg.sender == owner);
	require(withdrawn);
	uint balance = address(this).balance;
	if(balance>0){
	owner.transfer(balance);
}



}


  function stringToUint(string s) internal pure retunrs(uint result){

	bytes memory b = bytes(s);
	uint i;
	result = 0;
	for(i=0;i<b.length;i++)
	{
		uint c = uint(b[i]);
		if(c>=48 && c<=57){
		result = result*10+(c-48);
}



	}




}




   function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }
    
    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }
function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }
function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, "", "", "");
    }


}
