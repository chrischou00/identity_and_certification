pragma solidity >=0.4.0 <0.6.0;

contract giving{
    
    //Create a variable for each possible address
    event OpenDoor();
    mapping (address=>bool) private ownership;
    mapping(address=>uint256) private contract_time;
    //Save the owner address 
    address payable master;
    
    constructor() public{
        master = msg.sender;
        ownership[msg.sender] = true;
    }
    function checkPermission(uint num) public{
        require(ownership[msg.sender]==true, "You don't have permission");
        if(msg.sender != master)
            require(contract_time[msg.sender] >= now, "Your permission is out of date");
        emit OpenDoor();
    }
    function trans(uint daily) public payable{
        require(msg.value >= 100000000000000000*daily, "Please send enough money");
        master.transfer(100000000000000000*daily);
        contract_time[msg.sender] = now + daily * 1 days;
        ownership[msg.sender] = true;
    }
}