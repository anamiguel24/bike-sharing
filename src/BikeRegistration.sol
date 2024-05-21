// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BikeRegistration {
    struct Bike {
        uint256 id;                 // Unique identifier for the bike
        string model;
        uint32 modelYear;
        bool eletric;               // Flag indicating if the bike is eletric
        address lastRenter;         // Address of the last rider who rented the bike
        address currentRenter;      // Address of the current rider (0 address if not rented)
        uint256 rentalStartTime;    // Timestamp when the bike was rented
        uint256 rentalEndTime;      // Timestamp when the bike rental ends
        bool isAvailable;           // Flag indicating if the bike is available for rental
        uint nTrips;
        string stationCoordinates;  // Coordinates of the station where the bike it located, if its in use, is the location of the last station
    }
    
    mapping(uint => Bike) public bikes;
    uint public numBikes;

   event BikeRegistered(string model, uint32 modelYear, bool eletric, string stationCoordinates);
   // event Sold(address seller, uint price);
    uint public latestBikeId = 0;
    uint256[] public bikeIds;   // Array that will hold all the bikes ids, so we can easily access them later on

    function registerBike(string memory _model, uint32 _modelYear, bool _eletric, string memory _stationCoordinates) public {
        // require(_modelYear >= 1985 && _modelYear <= 2026, "Model year must be between 1985 and 2026");
        
        bikeIds.push(latestBikeId);
        bikes[latestBikeId] = Bike(latestBikeId, _model, _modelYear, _eletric, address(0), address(0), 0, 0, true, 0, _stationCoordinates);

        // update the latest bike ID
        latestBikeId++;
        // update the number of registered bikes
        numBikes++;
        emit BikeRegistered(_model, _modelYear, _eletric, _stationCoordinates);
    }

    // get the total number of registered bikes
    function getNumBikes() public view returns (uint) {
        return numBikes;
    }

    // Get the details of a specific bike
    function getBikeDetails(uint _index) public view returns (string memory model, uint32 modelYear, bool eletric, 
    address lastRenter, address currentRenter, uint256 rentalStartTime, uint256 rentalEndTime, bool isAvailable,
    uint nTrips, string memory stationCoordinates) {
        Bike memory bike = bikes[_index];
        return (bike.model, bike.modelYear, bike.eletric, bike.lastRenter, bike.currentRenter, bike.rentalStartTime, bike.rentalEndTime,
            bike.isAvailable, bike.nTrips, bike.stationCoordinates);
    }
}