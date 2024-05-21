// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BikeRegistration} from "../src/BikeRegistration.sol";

// unit test
contract BikeRegistrationTest is Test {
    BikeRegistration bikeRegistration;

    function setUp() public {
        bikeRegistration = new BikeRegistration();
    }

    function testRegisterBike() public {
        bikeRegistration.registerBike("Test Bike", 2022, true, "0,0");
        uint numBikes = bikeRegistration.getNumBikes();
        assertEq(numBikes, 1, "The number of registered bikes should be 1");
    }

    function testGetBike() public {
        bikeRegistration.registerBike("Test Bike", 2002, false, "0,0");
        (string memory model, uint32 modelYear, bool eletric, address lastRenter, address currentRenter, uint256 rentalStartTime, 
        uint256 rentalEndTime, bool isAvailable, uint nTrips, string memory stationCoordinates) = bikeRegistration.getBikeDetails(0);
        assertEq(model, "Test Bike", "The bike's model should be Test Bike");
        assertEq(modelYear, 2002, "The bike's model year should be 2002");
        assertFalse(eletric, "The bike shouldn't be eletric");
        assertEq(lastRenter, address(0), "The last renter should be address(0)");
        assertEq(currentRenter, address(0), "The current renter should be address(0)");
        assertEq(rentalStartTime, 0, "The bike's rental start time should be 0");
        assertEq(rentalEndTime, 0, "The bike's rental end time should be 0");
        assertTrue(isAvailable, "The bike should be available");
        assertEq(nTrips, 0, "The bike's number of trips should be 0");
        assertEq(stationCoordinates, "0,0", "The bike's station should be 0,0");
    }

}