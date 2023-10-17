// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract asset
{

    // DECLARATIONS
    struct bid
    {
        address addr;
        uint value;
    }

    address public asset_owner;
    
    address[] private owner_list;

    bid[] public bids;

    uint minimum_price;
    string asset_hash;

    address private constant registerAddress = 0x5801bd1Be6e6093745FCafA18De4b11217dDD0CE; //just a dummy address for now, feel free to change this

    //DO NOT CHANGE ANY FUNCTION HEADERS

    constructor(string memory dataHash)
    {
        // Code here
        asset_owner = tx.origin;
        owner_list.push(asset_owner);
        minimum_price = 0;
        asset_hash = dataHash;
    }

    function getHistoryOfOwners() public view returns(address[] memory)
    {
        // Code here
        return owner_list;
    }

    function getOwner() public view returns(address)
    {
        // Code here
        return asset_owner;
    }

    function getDataHash() public view returns(string memory)
    {
        // Code here
        return asset_hash;
    }

    function getMinimumPrice() public view returns(uint)
    {
        // Code here
        return minimum_price;
    }
    
    function setMinimumPrice(uint price) public 
    {
        //Only the owner may call this function
        require(tx.origin == asset_owner,"Only owner can call this function");

        // Code here
        minimum_price = price;
        uint i;
        for(i = 0; i < bids.length; i++)
        {
            if(bids[i].value < minimum_price)
            {
                payable(bids[i].addr).transfer(bids[i].value);
                bids[i] = bids[bids.length - 1];
                bids.pop();
            }
        }

        return;
    }

    function sell() public
    {
        //Only the owner may call this function
        require(tx.origin == asset_owner,"Only owner can call this function");
        //This function may only be called by the owner if there is at least one bid
        require(bids.length >= 1,"There should be at least 1 bid");
        

        // Code here
        uint i;
        bid memory largest = bids[0];
        for(i = 0; i < bids.length; i++)
        {
            if(bids[i].value > largest.value)
            {
                largest = bids[i];
            }
        }

        asset_owner = largest.addr;
        owner_list.push(asset_owner);

        for(i = 0; i < bids.length; i++)
        {
            if(bids[i].addr != largest.addr)
            {
                payable(bids[i].addr).transfer(bids[i].value);
            }
            else
            {
                payable(owner_list[owner_list.length - 2]).transfer(bids[i].value);
            }
        }

        // register call
        Register r = Register(registerAddress);
        r.submit("24100092",largest.value);
        delete bids;
        return;
    }

    function viewBid(uint index) public view returns(bid memory)
    {
        //Only the owner may call this function
        require(tx.origin == asset_owner,"Only owner can call this function");
        //This function should revert with an error "That bid number does not exist" if you try to access a bid number that does not exist.
        require(index < bids.length,"That bid number does not exist");
        // Code here
        bid memory temp = bids[index];
        return temp;
    }

    function getNumberOfBids() public view returns(uint)
    {
        //Only the owner may call this function
        require(tx.origin == asset_owner,"Only the owner can call this function");
        // Code here
        return bids.length;
    }

    function submitBid() public payable 
    {
        //The owner may not call this function
        require(tx.origin != asset_owner,"Owner can't call this function");
        //In addition, the bid must be higher than the minimum price defined by set minimum price as defined in the handout.
        // Code here
        
        uint i;
        bool exist = false;
        for(i = 0; i < bids.length; i++)
        {
            if(bids[i].addr == tx.origin)
            {
                exist =  true;
                break;
            }
        }

        if (exist == true)
        {
            bids[i].value += msg.value;
        }
        else
        {
            require(msg.value >= minimum_price,"Bids must offer more than minimumPrice");
            bid memory new_bid;
            new_bid.addr = tx.origin;
            new_bid.value = msg.value;

            bids.push(new_bid);
        }

        return;
    }

    function getOwnBidAmount() public view returns (uint)
    {
        // Code here
        uint i;
        for(i = 0; i < bids.length; i++)
        {
            if(bids[i].addr == tx.origin)
            {
                break;
            }
        }
        return bids[i].value;
    }
}

//DO NOT CHANGE ANYTHING IN THIS
contract Register
{
    struct submission
    {
        string rollNumber;
        uint Value;
    }

    function getHistory(uint index) public view returns (submission memory) {}
    
    function submit(string memory rollNumber, uint Value) public {}
}
