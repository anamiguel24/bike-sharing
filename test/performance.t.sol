// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {USDT} from "../src/USDT.sol";
import {RentalBike} from "../src/RentalAgreement.sol";
import {UserRegistration} from "../src/UserRegistration.sol";
import {BikeRegistration} from "../src/BikeRegistration.sol";

contract PerformanceTest is Test {
    USDT private usdt;
    UserRegistration private userRegistration;
    BikeRegistration private bikeRegistration;
    RentalBike private rentalAgreement;

    address private owner = address(1);
    address private user1 = address(2);
    address private user2 = address(3);

    function setUp() public {
        usdt = new USDT();
        userRegistration = new UserRegistration();
        bikeRegistration = new BikeRegistration();
        rentalAgreement = new RentalBike(address(usdt), address(userRegistration), address(bikeRegistration));

        usdt.approve(address(rentalAgreement), 30*10**18);

        // Register user and mint tokens
        userRegistration.registerRenter(user1, "renter1");
        usdt.mint(user1, 30 * 10**18);
        userRegistration.registerRenter(user2, "User2");
        usdt.mint(user2, 30 * 10**18);

        // Approve allowance from user1 for rentalAgreement
        vm.startPrank(user1);
        usdt.approve(address(rentalAgreement), 30*10**18);    
        vm.stopPrank();
    }

    // Test the Gas usage for the rental process
    function testGasUsageForRentingAndReturningBike() public {
        vm.startPrank(owner);
        bikeRegistration.registerBike("Bike1", 2014, false, "Aveiro school");
        bikeRegistration.registerBike("Bike2", 2018, true, "Lisbon school");
        vm.stopPrank();

        // event log_named_uint("Gas used for renting a bike", gasUsedRent);
        vm.startPrank(user1);

        uint amount = 30000;
        uint bikeId = 0;

        uint256 gasStart = gasleft();
        rentalAgreement.rentABike(amount, bikeId);
        uint256 gasUsedRent = gasStart - gasleft();
        emit log_named_uint("Gas used for renting a bike", gasUsedRent);

        gasStart = gasleft();
        rentalAgreement.returnABike(0, owner, 1, "Lisbon office");
        uint256 gasUsedReturn = gasStart - gasleft();
        emit log_named_uint("Gas used for returning a bike", gasUsedReturn);
        vm.stopPrank();
    }

    // transaction throughput, time taken for a 15min trip scenario
    function testTransactionThroughput() public {
        vm.startPrank(owner);
        bikeRegistration.registerBike("Bike1", 2014, false, "Aveiro school");
        vm.stopPrank();

        uint256 startTime = block.timestamp;
        uint rentalId = 0;

        for (uint256 i = 0; i < 200; i++) {
            vm.startPrank(user1);
            rentalAgreement.rentABike(1000, 0);
            rentalAgreement.returnABike(rentalId, owner, 0, "Lisbon office");
            vm.stopPrank();
            rentalId++;
        }

        uint256 endTime = block.timestamp;
        uint256 duration = endTime - startTime;
        emit log_named_uint("Time taken for 100 rent and return transactions (seconds)", duration);
    }

    function testRentAndReturnBikes() public {
        uint amount = 3;
        bikeRegistration.registerBike("Bikex", 2014, false, "Aveiro school");

        vm.startPrank(user1);
        
        // Measure time before transactions
        uint256 startTime = block.timestamp;
        
        for (uint i = 0; i < 100; i++) {
            rentalAgreement.rentABike(amount, 0);
            rentalAgreement.returnABike(i, owner, 0, "Lisbon office");
        }
        
        // Measure time after transactions
        uint256 endTime = block.timestamp;
        
        uint256 timeTaken = endTime - startTime;
        
        console.log("Time taken for 100 rent and return transactions (seconds):", timeTaken);
        
        vm.stopPrank();
    }

    // scalability capacity, i.e. number of users and bikes that the system can support
    // cost
}