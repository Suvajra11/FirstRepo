//SPDX-License-Identifier: Undefined 
pragma solidity ^0.8.7;

contract CryptoKids {
    //Owner Dad 
        address owner;

        event LogKidFundingRecived(address addr,uint  amount, uint contractBalance);
         
        constructor () {
            owner = msg.sender;
        }
    // define Kid 

        struct kid {
            address payable walletAddress;
            string firsName;
            string lastName;
            uint releseTime;
            uint amount;
            bool canWithdraw;
        }

        kid[] public kids;

        modifier onlyOwner {
                    require(msg.sender == owner, "Only owner can add kids");
                    _;

        }

// add kid to contract 
        function addKid(address payable walletAddress,  string memory firstName, string memory lastName,  uint releseTime, uint amount, bool canWithdraw) public onlyOwner {
            kids.push(kid(walletAddress,
            firstName,
            lastName,
            releseTime,
            amount,
            canWithdraw
            ));
        }
    // deposite funds to contract, specifically to kid's account

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    } 

    function deposite (address walletAddress) payable public  {
            addKidsBalance(walletAddress);
    }


        function addKidsBalance(address walletAddress) private onlyOwner {
            for(uint i = 0; i < kids.length ; i++) {
                if(kids[i].walletAddress == walletAddress) {
                    kids[i].amount += msg.value; 
                    emit LogKidFundingRecived(walletAddress, msg.value, balanceOf());
                }
            }

        } 

            function getIndex(address walletAddress) view private returns(uint) { 
                for(uint i = 0; i < kids.length; i++) {
                     if (kids[i].walletAddress == walletAddress){
                         return 1;
                     }
                }
                                return 999; 

            }
    // kids check if able to withdraw

            function avaliableToWithdraw(address walletAddress)public returns(bool) {
                uint i = getIndex(walletAddress);
                    require(block.timestamp > kids[i].releseTime,"You cannot withdraw yet");
                if (block.timestamp > kids[i].releseTime){
                    kids[i].canWithdraw = true;
                    return true;
                } else {
                    return false;
                }
            }
    //withdraw money
        function withdraw( address payable walletAddress) payable public {
            uint i = getIndex(walletAddress);
            require(msg.sender == kids[i].walletAddress, "You must be kids that withdraw");
            require(kids[i].canWithdraw == true, "You cannot withdraw at this time ");
            kids[i].walletAddress.transfer(kids[i].amount); 
        }

}