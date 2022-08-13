// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

    contract Lottery {
        
        event BuyerID (string indexed BuyerName, uint indexed Amount);
        
        uint TicketPrice;
        uint AllMoney;
        uint OwnerPercentage;
        uint WinnerMoney = AllMoney - OwnerPercentage;
        uint EndTime;
        uint BIndex = 0;
        uint AllTickets;
        bool IsStarted;
        bool IsEnd;
        address Owner;
        

       constructor(uint _TicketPricePerOneWei , uint _EndTimeByDay) {
           Owner = msg.sender ;
           TicketPrice = (_TicketPricePerOneWei * 1 wei);
           OwnerPercentage = (AllTickets * 185 / 10000);
           EndTime = block.timestamp + (_EndTimeByDay * 1 seconds);
       }

        modifier OnlyOwner {
            require(Owner == msg.sender);
            _;
        }

        struct Buyer {
            string BName;
            uint BId;
            uint TicketAmount;
            address TicketOwner;
            bool IsWon;
        }
        Buyer[] Buyers;
        mapping (uint => Buyer) WinnerMap;

        function _TickePrice() public view returns(uint) {
            return TicketPrice;
        }

        function BuyTicket(string memory _BName, uint _TicketAmount) public payable {
            require(msg.value >= (TicketPrice * _TicketAmount), "you dont have enough money!");
            require(EndTime > block.timestamp, "times Up :(" );
            AllMoney = (_TicketAmount + AllTickets) * (TicketPrice);
            BIndex = BIndex + _TicketAmount;
            Buyers.push(Buyer( _BName, BIndex, _TicketAmount, msg.sender, false));
            payable(msg.sender).transfer(msg.value);
            emit BuyerID ( _BName, _TicketAmount);
        }
        function startlottery() public OnlyOwner {
            require(block.timestamp > EndTime);
            require(IsStarted == false);
            IsStarted = true;
            uint WinnerIndex = random(BIndex);
            WinnerMap[WinnerIndex].IsWon = true;
            payable(WinnerMap[WinnerIndex].TicketOwner).transfer(WinnerMoney);
            IsEnd = true;
        }
        function random(uint count) private view returns(uint) {
            uint rand = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty))) % count;
            return rand;
        }
    }
    