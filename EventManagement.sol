// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract EventManagement {

    struct Event{
          address organizer;
    string EventName;
    uint date;
    uint priceOfTicket;
    uint TotelTicket;
    uint RemainingTickets;
    }

    mapping (uint => Event) public events;
    mapping (address => mapping (uint => uint)) public tickets;

    uint  nextID;
    function addEvent(string memory _EventName , uint _priceOfTicket,uint _date,uint _TotelTicket)public {
        require(_date>block.timestamp,"Create Event for Future");
        require(_TotelTicket>0,"ticket should  be more than 0");
       events[nextID] = Event(msg.sender,_EventName,_date,_priceOfTicket,_TotelTicket,_TotelTicket);
       nextID++;
    }
    function buyTicket(uint id , uint quantity)public payable {
        require(events[id].date!=0,"event dosn't exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value==(_event.priceOfTicket*quantity),"Add exect amount of ether");
        require(_event.TotelTicket>quantity,"Quantity is more than total tickets");
        tickets[msg.sender][id] += quantity;
    }
    function transferTicket(address _to,uint quantity, uint _id) public {
        require(events[_id].date!=0,"event dosn't exist");
        require(events[_id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][_id]>quantity,"you don't have enough tickets");
        tickets[msg.sender][_id]-=quantity;
        tickets[_to][_id] += quantity;
    }

  
}
