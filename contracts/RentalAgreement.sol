//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./UserRegistration.sol";
import "./token/ERC20.sol";

contract RentalBike {
    address owner;
    UserRegistration userRegistration;
    ERC20 public usdtContract; // MyUSDT contract interface


    constructor(address _usdtContract, address _user) {
        owner = msg.sender;
        userRegistration = UserRegistration(_user);
        usdtContract = ERC20(_usdtContract);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the Owner can call this function");
        _;
    }

    struct Rental {
        uint rentalId;
        address renterAddress;  // Address of the renter
        uint balance;
        uint256 startDate;      // Start time of the rental agreement (timestamp)
        uint256 endDate;
        uint pricePerHour;
        uint256 rentalFee;      // Fee for the rental agreement
        bool isActive;          //true when the rental agreement is initiated and set to false when the bicycle is returned
    } 

    mapping(uint256 => Rental) public rentals; 
    uint public numberOfRentals=0;
    uint public latestRentalId = 0;
    uint256[] public rentalIds;   // Array that will hold all the rental ids, so we can easily access them later on


    // function that allows a renter rent a bike
    function rentABike(uint _amount) public {
        // check if the renter is registered and if the bike is available
        (, , , bool isRegistered,) = userRegistration.getRenterDetails(msg.sender);
        require(isRegistered, "Renter is not registered.You need to be registered first!");

        // Transfer USDT tokens to this contract
        require(usdtContract.transferFrom(msg.sender, address(this), _amount), "USDT transfer failed");

        // create a new rental record
        rentalIds.push(latestRentalId);
        rentals[latestRentalId] = Rental(latestRentalId, msg.sender, _amount, block.timestamp, 0, 1, 0, true);

        // update the number of active rentals
        numberOfRentals++;
        // update the latest rental ID
        latestRentalId++;
    }

    // function that returns a bike to be used again
    function returnABike(uint _rentalId, address _serviceOwner) public {
        Rental storage rental = rentals[_rentalId];
        require(rental.isActive, "Rental agreement is not active");
        (, , , , uint nTrips) = userRegistration.getRenterDetails(msg.sender);

        rental.endDate = block.timestamp;

        // Calculate the rental fee. If it the 5th trip then it's free
        if (nTrips == 5){
            rental.pricePerHour = 0;
            rental.rentalFee = 0;
        } else {
            require(rental.endDate >= rental.startDate, "End date must be greater than or equal to start date");
            rental.rentalFee = ((rental.endDate - rental.startDate)/60) * rental.pricePerHour;
            // Transfer rental fee to serviceOwner
            require(usdtContract.transfer(_serviceOwner, rentals[_rentalId].rentalFee), "USDT transfer failed");
            // Update remaining balance
            rental.balance -= rental.rentalFee;
        }
        
        // Return remaining balance to renter
        if (rental.balance > 0) {
            require(usdtContract.transfer(msg.sender, rental.balance), "USDT refund failed");
            rental.balance = 0;
        }

        // End rental agreement
        rental.isActive =  false;
    }

    // Get total duration of a bike use/trip
    function getDuration(uint256 _startDate, uint256 _endDate) internal pure returns(uint){
        require(_endDate >= _startDate, "End date must be greater than or equal to start date");
        return (_endDate - _startDate)/60;   // Duration is returned in minutes
    }
}