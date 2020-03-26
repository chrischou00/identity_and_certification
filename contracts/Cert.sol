pragma solidity >= 0.4.0 < 0.6.0;

contract Cert{
    
    struct Attribute{
        uint ID;
        string name;
        string data;
        address payable[] signer;
        uint update_time;
        uint duration_time;
        uint duration_number;
        bool give_back;
        uint paytime;
        bool first_flag;
    }
    struct Signature{
        address target;
        uint ID;
    }
    struct Identity {
        bool exist;
        Attribute[] attrib_list;
        Signature[] sign_list;
    }
    address payable[] exist_list;
    mapping(address=>Identity) identifiers;
    
    function addAttribute(string memory name, string memory data) public{
        if(identifiers[msg.sender].exist == false)
        {
            exist_list.push(msg.sender);
            identifiers[msg.sender].exist = true;
        }
        Attribute memory temp;
        temp.ID = identifiers[msg.sender].attrib_list.length;
        temp.name = name;
        temp.data = data;
        temp.update_time = now+ 1*30 days;
        temp.duration_number = 0;
        temp.duration_time = now;
        temp.give_back = true;
        temp.paytime = 0;
        identifiers[msg.sender].attrib_list.push(temp);
    }
    
    function Sign(address target, uint id) public payable{
        require(target != msg.sender, "you can't sign your own attribute!");
        require(id < identifiers[target].attrib_list.length, "No such attribute exist!");
        require(msg.value >= 100000000000000000, "You need to pay more money");
        require(identifiers[target].attrib_list[id].update_time > now, "This Attribute is Time Up!");

        if(identifiers[msg.sender].exist == false)
        {
            exist_list.push(msg.sender);
            identifiers[msg.sender].exist = true;
        }
        for(uint i=0; i< identifiers[target].attrib_list[id].signer.length; i++)
        {
            require(identifiers[target].attrib_list[id].signer[i]!= msg.sender, "You have already sign this attribute!");
        }
        identifiers[target].attrib_list[id].signer.push(msg.sender);
        Signature memory temp;
        temp.target = target;
        temp.ID = id;
        identifiers[msg.sender].sign_list.push(temp);
    }
    function getAttribute(address target, uint ID) public view returns(string memory, string memory, uint, uint){
        require(ID < identifiers[target].attrib_list.length, "No such attribute exist!");
        require(identifiers[target].attrib_list[ID].update_time > now, "This Attribute is Time Up!");
        return (identifiers[target].attrib_list[ID].name, identifiers[target].attrib_list[ID].data, identifiers[target].attrib_list[ID].update_time, identifiers[target].attrib_list[ID].signer.length);
    }
    
    function revokeSignature(address target, uint ID) public payable{
        require(ID < identifiers[target].attrib_list.length, "No such attribute exist!");
        uint i=0;
        for(i=0; i< identifiers[msg.sender].sign_list.length; i++)
        {
            if(identifiers[msg.sender].sign_list[i].target==target && identifiers[msg.sender].sign_list[i].ID==ID)
            {
                if(identifiers[target].attrib_list[ID].give_back == true)
                {
                    msg.sender.transfer(100000000000000000);
                }
                
                identifiers[msg.sender].sign_list[i] = identifiers[msg.sender].sign_list[identifiers[msg.sender].sign_list.length-1];
                identifiers[msg.sender].sign_list.length--;
                for(uint j=0; j< identifiers[target].attrib_list[ID].signer.length; j++)
                {
                    if(identifiers[target].attrib_list[ID].signer[j]==msg.sender)
                    {
                        identifiers[target].attrib_list[ID].signer[j] = identifiers[target].attrib_list[ID].signer[identifiers[target].attrib_list[ID].signer.length-1];
                        identifiers[target].attrib_list[ID].signer.length--;
                    }
                }
                return;
            }
        }
        require(i < identifiers[msg.sender].sign_list.length, "You don't have such signature!");
    }

    function updateAttribute(uint ID, string memory data)public payable{
        require(ID < identifiers[msg.sender].attrib_list.length, "No such attribute exist!");
        if(now > identifiers[msg.sender].attrib_list[ID].update_time && identifiers[msg.sender].attrib_list[ID].paytime == 0)
        {
            identifiers[msg.sender].attrib_list[ID].give_back = false;
            identifiers[msg.sender].attrib_list[ID].paytime++;
            uint temp;
            temp = identifiers[msg.sender].attrib_list[ID].signer.length;
            for(uint k=0; k < temp; k++)
            {
                exist_list[k].transfer(100000000000000000);
                exist_list.push(exist_list[k]);
            }
            
            for(uint k=0; k+temp < exist_list.length; k++)
            {
                exist_list[k] = exist_list[k+temp];
            }
            exist_list.length = exist_list.length - temp;
        }
        identifiers[msg.sender].attrib_list[ID].data = data;
        if(identifiers[msg.sender].attrib_list[ID].give_back == true)
        {
            for(uint i=0; i < identifiers[msg.sender].attrib_list[ID].signer.length; i++)
            {
                identifiers[msg.sender].attrib_list[ID].signer[i].transfer(100000000000000000);
                for(uint j=0; j< identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list.length;j++)
                {
                    if(identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list[j].target == msg.sender && identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list[j].ID==ID)
                    {
                        uint temp = identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list.length;
                        identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list[j] = identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list[temp-1];
                        identifiers[identifiers[msg.sender].attrib_list[ID].signer[i]].sign_list.length--;
                    }
                }
            }
        }
        identifiers[msg.sender].attrib_list[ID].signer.length = 0;
        identifiers[msg.sender].attrib_list[ID].update_time = now+ 30 * 1 days;
        identifiers[msg.sender].attrib_list[ID].duration_number = 0;
        identifiers[msg.sender].attrib_list[ID].duration_time = now;
        identifiers[msg.sender].attrib_list[ID].give_back = true;
    }
    function show() public view returns(address){
        return (identifiers[msg.sender].sign_list[0].target);
    }
    function need(uint ID)public view returns(uint){
        return identifiers[msg.sender].attrib_list[ID].duration_number;
    }
    
    function show_after(uint ID)public view returns(uint, uint, uint){
        return (identifiers[msg.sender].attrib_list[ID].duration_number, identifiers[msg.sender].attrib_list[ID].duration_time, identifiers[msg.sender].attrib_list[ID].update_time);
    }
    
    function extendTime(uint ID)public payable{
        require(ID < identifiers[msg.sender].attrib_list.length, "No such attribute exist!");
        if(now > identifiers[msg.sender].attrib_list[ID].update_time && identifiers[msg.sender].attrib_list[ID].paytime == 0)
        {
            identifiers[msg.sender].attrib_list[ID].give_back = false;
            identifiers[msg.sender].attrib_list[ID].paytime++;
            uint temp;
            temp = identifiers[msg.sender].attrib_list[ID].signer.length;
            for(uint k=0; k < temp; k++)
            {
                exist_list[k].transfer(100000000000000000);
                exist_list.push(exist_list[k]);
            }
            
            for(uint k=0; k+temp < exist_list.length; k++)
            {
                exist_list[k] = exist_list[k+temp];
            }
            exist_list.length = exist_list.length - temp;
        }
        if(now < identifiers[msg.sender].attrib_list[ID].duration_time)
        {
            require(identifiers[msg.sender].attrib_list[ID].duration_number * 100000000000000000 <= msg.value, "You should pay more fee!");
            identifiers[msg.sender].attrib_list[ID].duration_number++;
            identifiers[msg.sender].attrib_list[ID].duration_time = identifiers[msg.sender].attrib_list[ID].update_time;
            identifiers[msg.sender].attrib_list[ID].update_time = identifiers[msg.sender].attrib_list[ID].update_time + 30*1 days;
        }
        else
        {
            identifiers[msg.sender].attrib_list[ID].duration_number = 0;
            identifiers[msg.sender].attrib_list[ID].duration_time = identifiers[msg.sender].attrib_list[ID].update_time;
            identifiers[msg.sender].attrib_list[ID].update_time = identifiers[msg.sender].attrib_list[ID].update_time + 30*1 days;
        }
    }
}