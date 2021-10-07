// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

contract LuckyDraw {
    // tip: 0.1 ether = 10^17 wei = 100000000000000000 wei
    
    address public Owner;
    address[] public investors;  //Dynamic Array so that any & many times User can join multiple times
    
    uint random;
    address payable public Winner;
    
    //events
    event winnerPerson(address _Winner, uint _Amt);
    event registered(address _Person, uint _Amt);
    
    constructor() {
        Owner = msg.sender;  //Owner of the contract is assigned as soon as the contract begins.
    }
    
    //shows the Whole balance of the contract
    function getBalance() public view returns(uint Balance) {
        return address(this).balance;
    }
    
    function invest() public payable {
        
        //Users pay a fixed price of 0.1 ether to join.
        require(msg.value == 0.1 ether, "Pay only fixed amt of 0.1 ether");
        
        //keeping track of who all invested(their address)
        investors.push(msg.sender);
        
        emit registered(msg.sender, msg.value);
    }
    
    function generateRandomnumber() private{
        //creatng a pseudo random no.
        //first take some globalvariables
        //then encrypt investor
        //then hash it
        //then convert the result into uint and store it in "random"
        //hence we got the random no.
        random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, investors.length)));
    }
    
    function selectWinner() public {
        require(msg.sender == Owner, "Only Owner can access this"); //Owner can pick winner on its own time
        
        //After generating a random no we are reducing the no to Winnerindex no.
        uint winnerIndex = random % investors.length;
        
        //and then matching the Winnerindex no with the array index no.
        //when found, declaring the array index no. as the winner.
        Winner = payable(investors[winnerIndex]);
        
        emit winnerPerson(Winner, address(this).balance);
        
        Winner.transfer(address(this).balance); //The winner receives all the reward money.
        
        investors = new address payable [](0); 
        //New Lottery when the winner is picked but with the same Owner.
        
    }
    
    
}
