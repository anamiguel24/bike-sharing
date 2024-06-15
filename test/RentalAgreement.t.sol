// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {USDT} from "../src/USDT.sol";
import {RentalBike} from "../src/RentalAgreement.sol";
import {UserRegistration} from "../src/UserRegistration.sol";
import {BikeRegistration} from "../src/BikeRegistration.sol";

contract RentarAgreementTest is Test {
    USDT usdt;
    UserRegistration userRegistration;
    BikeRegistration bikeRegistration;
    RentalBike rentalAgreement;

    function setUp() public {
        usdt = new USDT();
        userRegistration = new UserRegistration();
        bikeRegistration = new BikeRegistration();
        rentalAgreement = new RentalBike(address(usdt), address(userRegistration), address(bikeRegistration));
        
        // Register user and mint tokens
        userRegistration.registerRenter(address(1), "renter1");
        usdt.mint(address(1), 30 * 10**18);
        // Register bike
        bikeRegistration.registerBike("fast", 2014, false, "Aveiro school");

        // Approve allowance from user1 for rentalAgreement
        vm.startPrank(address(1));
        usdt.approve(address(rentalAgreement), 30*10**18);    
        vm.stopPrank();
    }

    function testRentABike() public {
        uint amount = 3;
        uint bikeId = 0;

        vm.startPrank(address(1));
        rentalAgreement.rentABike(amount, bikeId);
        console.log("Successfull rentABike");
        vm.stopPrank();
    }

    function testReturnABike() public {
        address user = address(1);
        address serviceOwner = address(3);
        uint bikeId = 0;
        uint rentalId = 0; 
        string memory stationCoordinates = "Lisbon";

        // Set up a rental agreement
        vm.prank(user);
        rentalAgreement.rentABike(200, bikeId);
        rentalAgreement.returnABike(rentalId, serviceOwner, bikeId, stationCoordinates);
        vm.stopPrank();
        
        console.log("Successfull returnABike");
    }

    function testRentalFeeIsFreeAfter5Trips() public {
        address serviceOwner = address(2);
        string memory stationCoordinates = "Aveiro4";
        uint amount = 10;
        uint bikeId = 0;
        uint rentalId = 0;

        // Set up the user with 5 trips
        for (uint i = 0; i < 5; i++) {
            vm.startPrank(address(1));
            rentalAgreement.rentABike(amount, bikeId);
            rentalAgreement.returnABike(rentalId, serviceOwner, bikeId, stationCoordinates);
            bikeRegistration.registerBike("fast", 2014, false, "Aveiro school");
            vm.stopPrank();
            bikeId++;
            rentalId++;
        }
    }

}