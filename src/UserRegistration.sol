// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UserRegistration {

    uint public totalRenters;

    // Add a renter
    struct Renter {
        address walletAddress; //address payable walletAddress;
        string name;
        bool canRent; 
        uint balance;
        bool isRegistered;
        uint nTrips;
    }
    
    mapping(address => Renter) public renters; 

    event UserRegistered(address indexed walletAddress, string name);

    constructor() {
        totalRenters = 0;
    }

    // Function to register a new user
    function registerRenter (address _walletAddress, string memory _name) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(!renters[_walletAddress].isRegistered, "User already exists.");  
        
        renters[_walletAddress] = Renter(_walletAddress, _name, true, 0, true, 0);  // msg.sender

        totalRenters++;
        emit UserRegistered(_walletAddress, _name);
    }

    // Get the details of a specific renter
    function getRenterDetails(address _walletAddress) public view returns (string memory name, bool canRent, 
    uint balance, bool isRegistered, uint nTrips){
        Renter memory r = renters[_walletAddress]; // calldata //use memory instead of store to save gas, since you're only reading data and not modifying it
        return (r.name, r.canRent, r.balance, r.isRegistered, r.nTrips); 
    }
}