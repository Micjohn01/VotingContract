//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract VotingContract {
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public votingPower;
    uint256 public votingStart;
    uint256 public votingEnd;

    event ProposalAdded(uint256 indexed proposalId, string description);
    event Voted(address indexed voter, uint256 indexed proposalId);

    function initialize(uint256 _votingDuration) public {
        require(votingStart == 0, "Already initialized");
        votingStart = block.timestamp;
        votingEnd = votingStart + _votingDuration;
    }

    function addProposal(string memory _description) public {
        require(block.timestamp < votingEnd, "Voting has ended");
        proposals.push(Proposal(_description, 0));
        emit ProposalAdded(proposals.length - 1, _description);
    }

    function vote(uint256 proposalId) public {
        require(block.timestamp >= votingStart && block.timestamp < votingEnd, "Voting is not active");
        require(!hasVoted[msg.sender], "Already voted");
        require(proposalId < proposals.length, "Invalid proposal");

        proposals[proposalId].voteCount += votingPower[msg.sender] > 0 ? votingPower[msg.sender] : 1;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, proposalId);
    }

    function assignVotingPower(address voter, uint256 power) public {
        // In a real contract, this should be restricted to an admin or governance mechanism
        votingPower[voter] = power;
    }

    function getWinningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
}