//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

contract MultiOwnable {
    string public name = "Multiownable Token";
    string public symbol = "MOT";
    uint256 public decimals;

    uint256 public totalSupply = 100 ether;

    mapping(address => bool) public owner;
    mapping(address => bool) public promotedCandidate;
    mapping(address => bool) public isVoted;
    address public confirmedCandidate;
    uint256 public ownersNumber;
    uint256 votesTrue;
    uint256 votesFalse;

    mapping(address => uint256) balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    modifier onlyOwner() {
        require(owner[msg.sender], "Not an owner");
        require(!owner[address(0)], "wrong address constructor");
        _;
    }

    constructor() {
        owner[msg.sender] = true;
        balances[msg.sender] = totalSupply;
        ownersNumber ++;
        decimals = 18;
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function promoteCandidate(address _newCandidate) external onlyOwner{
        require(_newCandidate != address(0), "wrong address promoteCandidate");
        require(!promotedCandidate[_newCandidate], "Already candidate");
        require(!owner[_newCandidate], "Already owner");
        promotedCandidate[_newCandidate] = true;
        if(promotedCandidate[_newCandidate] == true) {
        confirmedCandidate = _newCandidate;
         promotedCandidate[_newCandidate] = false;
        }
    }

    function vote(bool _option) external onlyOwner {
        require(!isVoted[msg.sender], "Already voted");
        require(confirmedCandidate != address(0), "wrong address");
        isVoted[msg.sender] = true;
        if(_option == true) {
            votesTrue++;
        } else {
            votesFalse++;
        }
        if(votesTrue > ownersNumber / 2 || votesFalse >= ownersNumber / 2) {
            if(votesTrue > ownersNumber / 2 ){
            owner[confirmedCandidate] = true;
            ownersNumber ++;
            isVoted[msg.sender] = false;
            votesTrue = 0;
            votesFalse = 0;
        }
        confirmedCandidate = address(0);
        isVoted[msg.sender] = false;
        votesTrue = 0;
        votesFalse = 0;
        }
    }

    function clearVote() external onlyOwner {
        require(isVoted[msg.sender], "Not voted yet");
        isVoted[msg.sender] = false;
    }
}
