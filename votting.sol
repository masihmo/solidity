    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.13;
    contract votting { 

        struct Candidate {
            string Name;
            uint Id;
            uint VoteCount;
        }

        Candidate[] _Candidate;
        
        uint _Id;

        address Owner;

        mapping (uint => Candidate) Candidates;
        mapping (address => bool) VoteRecorded;

        constructor() {
        Owner = msg.sender;
        }

        modifier OnlyOwner(){
            require (msg.sender == Owner , "you are not the owner");
        _;
        }

        function SetCandidate(string memory _Name) public OnlyOwner {
            _Id++;
            _Candidate.push(Candidate(_Name, _Id, 0));
            Candidates[_Id] =Candidate(_Name, _Id, 0);
        }

        function ViewCandidate() public view returns(Candidate[] memory) {
            return _Candidate;
        }

        function SetVote(uint VoteId) public returns(string memory) {    
            require(VoteRecorded[msg.sender] == false);
            require(VoteId <= _Id && VoteId != 0,  "Vote id not found" );
            VoteRecorded[msg.sender] = true;
            Candidates[VoteId].VoteCount++;

            return "you vote has been submit "; 
        }
        function Winner() public view returns (uint, string memory) {
            uint  WinnerVote;
            string memory WinnerName;
            
            for (uint i = 0; i <= _Id; i++) {
                if (Candidates[i].VoteCount > WinnerVote) {
                    WinnerVote = Candidates[i].VoteCount;
                    WinnerName = Candidates[i].Name;
                }
            }
            return (WinnerVote, WinnerName);
        }

    
}