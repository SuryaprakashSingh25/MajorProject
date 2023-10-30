pragma solidity >= 0.5.2;
//pragma solidity ^0.6.0;

contract Land {
    address contractOwner;

    struct Landreg {
        uint id;
        uint area;
        string city;
        string state;
        uint landPrice;
        uint propertyPID;
        uint physicalSurveyNumber;
        //string ipfsHash;
        string document;
        bool isforSell;
        address payable ownerAddress;
        bool isLandVerified;
    }

    struct User{
        address id;
        string name;
        uint age;
        string city;
        string aadharNumber;
        string panNumber;
        string document;
        string email;
       // uint[] mylands;
        bool isUserVerified;
    }

     struct LandInspector {
        uint id;
        address _addr;
        string name;
        uint age;
        string designation;
        string city;
    }

    struct LandRequest{
        uint reqId;
        address payable sellerId;
        address payable buyerId;
        uint landId;
        reqStatus requestStatus;
        bool isPaymentDone;
        // bool requested;
    }
    enum reqStatus {requested,accepted,rejected,paymentdone,commpleted}

    constructor() public{
        contractOwner = msg.sender ;
    }
    uint inspectorsCount;
    uint userCount;
    uint landsCount;
    uint requestCount;


    mapping(address => LandInspector) public InspectorMapping;
    mapping(address => bool) public RegisteredInspectorMapping;
    mapping(address => User) public UserMapping;
    mapping(uint => address) public AllUsers;
    mapping(uint => address[]) public allUsersList;
    mapping(address => bool) public RegisteredUserMapping;
    mapping(address => uint[]) public MyLands;
    mapping(uint => Landreg) public lands;
    mapping(uint => LandRequest) public LandRequestMapping;
    mapping(address => uint[]) public MyLandRequest;


    function isContractOwner(address _addr) public view returns(bool){
        if(_addr==contractOwner)
            return true;
        else
            return false;
    }

     //-----------------------------------------------LandInspector-----------------------------------------------

    function addLandInspector(address _addr,string memory _name, uint _age, string memory _designation,string memory _city) public returns(bool){
        if(contractOwner!=msg.sender)
            return false;
        require(contractOwner==msg.sender);
        RegisteredInspectorMapping[_addr]=true;
        InspectorMapping[_addr] = LandInspector(inspectorsCount,_addr,_name, _age, _designation,_city);
        return true;
    }
     function isLandInspector(address _id) public view returns (bool) {
        if(RegisteredInspectorMapping[_id]){
            return true;
        }else{
            return false;
        }
    }



   //-----------------------------------------------User-----------------------------------------------

   function isUserRegistered(address _addr) public view returns(bool)
   {
       if(RegisteredUserMapping[_addr]){
            return true;
        }else{
            return false;
        }
   }

    function registerUser(string memory _name, uint _age, string memory _city,string memory _aadharNumber, string memory _panNumber, string memory _document, string memory _email
    ) public {

        require(!RegisteredUserMapping[msg.sender]);

        RegisteredUserMapping[msg.sender] = true;
        userCount++;
        allUsersList[1].push(msg.sender);
        AllUsers[userCount]=msg.sender;
        UserMapping[msg.sender] = User(msg.sender, _name, _age, _city,_aadharNumber,_panNumber, _document,_email,false);
        //emit Registration(msg.sender);
    }

    function verifyUser(address _userId) public{
        require(isLandInspector(msg.sender));
        UserMapping[_userId].isUserVerified=true;
    }
    function isUserVerified(address id) public view returns(bool){
       return UserMapping[id].isUserVerified;
    }
    function ReturnAllUserList() public view returns(address[] memory)
    {
        return allUsersList[1];
    }


     //-----------------------------------------------Land-----------------------------------------------
    function addLand(uint _area, string memory _city,string memory _state, uint landPrice, uint _propertyPID,uint _surveyNum, string memory _document) public {
        require(isUserVerified(msg.sender));
        landsCount++;
        lands[landsCount] = Landreg(landsCount, _area, _city, _state, landPrice,_propertyPID, _surveyNum , _document,false,msg.sender,false);
        MyLands[msg.sender].push(landsCount);
        // emit AddingLand(landsCount);
    }
    function verifyLand(uint _id) public{
        require(isLandInspector(msg.sender));
        lands[_id].isLandVerified=true;
    }
    function isLandVerified(uint id) public view returns(bool){
      return lands[id].isLandVerified;
    }

    function myAllLands(address id) public view returns( uint[] memory){
        return MyLands[id];
    }
    function landInfo(uint id) public view returns(uint,string memory,string memory,uint,string memory,bool,address) {
        return (lands[id].area,lands[id].city,lands[id].state,lands[id].landPrice,lands[id].document,lands[id].isforSell,lands[id].ownerAddress);
    }

    function makeItforSell(uint id) public{
        require(lands[id].ownerAddress==msg.sender);
        lands[id].isforSell=true;
    }

    function requestforBuy(uint _landId) public
    {
        require(isUserVerified(msg.sender) && isLandVerified(_landId));
        requestCount++;
        LandRequestMapping[requestCount]=LandRequest(requestCount,lands[_landId].ownerAddress,msg.sender,_landId,reqStatus.requested,false);
        MyLandRequest[lands[_landId].ownerAddress].push(requestCount);
    }

   function myAllLandRequests() public view returns(uint[] memory)
   {
      return MyLandRequest[msg.sender];
   }
    function acceptRequest(uint _requestId) public
    {
        require(LandRequestMapping[_requestId].sellerId==msg.sender);
        LandRequestMapping[_requestId].requestStatus=reqStatus.accepted;
    }
    function rejectRequest(uint _requestId) public
    {
        require(LandRequestMapping[_requestId].sellerId==msg.sender);
        LandRequestMapping[_requestId].requestStatus=reqStatus.rejected;
    }

    function landPrice(uint id) public view returns(uint)
    {
        return lands[id].landPrice;
    }
    function makePayment(uint _requestId) public payable
    {
        require(LandRequestMapping[_requestId].buyerId==msg.sender && LandRequestMapping[_requestId].requestStatus==reqStatus.accepted);

        LandRequestMapping[_requestId].requestStatus=reqStatus.paymentdone;
        //LandRequestMapping[_requestId].sellerId.transfer(lands[LandRequestMapping[_requestId].landId].landPrice);
        //lands[LandRequestMapping[_requestId].landId].ownerAddress.transfer(lands[LandRequestMapping[_requestId].landId].landPrice);
        lands[LandRequestMapping[_requestId].landId].ownerAddress.transfer(msg.value);
        LandRequestMapping[_requestId].isPaymentDone=true;

    }

    function transferOwnership(uint _requestId) public returns(bool)
    {
        require(isLandInspector(msg.sender));
        if(LandRequestMapping[_requestId].isPaymentDone==false)
            return false;
        LandRequestMapping[_requestId].requestStatus=reqStatus.commpleted;
        lands[LandRequestMapping[_requestId].landId].ownerAddress=LandRequestMapping[_requestId].buyerId;
        return true;
    }
    function makePaymentTestFun(address payable _reveiver) public payable
    {
        _reveiver.transfer(msg.value);
    }
}