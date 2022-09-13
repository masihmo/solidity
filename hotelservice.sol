// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;


contract HotelService {


    event SignUpEvent(address Owner,string indexed UserName, string indexed UserLastName, uint UserPrice);
    event EnteredRome(address indexed  Owner);

    struct Details {
        string Name;
        string LastName;
        uint price;
        uint Key;
        uint Days;
    }
    
    
    Details[] Detail;
    uint index;
    uint Time;
    address Owner;
    bool SignUpBool;
    bool PayBool;
    bool ServiceStarted;
    mapping  (address => Details) MapDetails;


    modifier onlyOwner() {
        require(msg.sender == Owner, "Not owner");
        _;
    }

    
    function SignUp(string memory _Name, string memory _LastName, uint _Days) public {
        index++;
        Detail.push(Details( _Name, _LastName, (_Days * 1) , uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))), _Days));
        MapDetails[msg.sender].price = (_Days * 1 wei);
        MapDetails[msg.sender].Key = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        SignUpBool = true;
        ServiceStarted = true;
        Owner = msg.sender;
        emit SignUpEvent(Owner ,_Name, _LastName, MapDetails[msg.sender].price);
    }

    function PayPrice() public view returns(uint) {
        return MapDetails[msg.sender].price;
    }

    function Pay() public payable {
        require(msg.value == MapDetails[msg.sender].price, "please enter correct value");
        PayBool = true;
        Time = block.timestamp;
    }

    function GetYourKey() public view returns(uint){
        require(SignUpBool == true, "please signup first");
        require(PayBool == true, "please pay first");
        return MapDetails[msg.sender].Key;
    }

    function EnterYourRome(uint EnterYourKey) public onlyOwner {
        require(EnterYourKey == MapDetails[msg.sender].Key , "Enter The Correct Key");
        require(ServiceStarted == true, "");

        if (block.timestamp > Time +(MapDetails[msg.sender].Days * 86400)) {
            ServiceStarted = false;
        }
        emit EnteredRome(msg.sender);
        //after this function called successfully you are going to see your room in front end
    }
    
    function DaysRemain() public view onlyOwner returns(Details memory)  {
        require(SignUpBool == true, "SignUp First");
        return MapDetails[msg.sender];
    }
    
 
}
