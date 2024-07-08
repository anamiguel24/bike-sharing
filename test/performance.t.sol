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
    address private renter1 = address(2);
    address private serviceOwner = address(3);

    function setUp() public {
        usdt = new USDT();
        userRegistration = new UserRegistration();
        bikeRegistration = new BikeRegistration();
        rentalAgreement = new RentalBike(address(usdt), address(userRegistration), address(bikeRegistration));

        usdt.approve(address(rentalAgreement), 30*10**18);

        // Register user and mint tokens
        userRegistration.registerRenter(renter1, "renter1");
        usdt.mint(renter1, 30 * 10**18);
        userRegistration.registerRenter(serviceOwner, "serviceOwner");
        usdt.mint(serviceOwner, 30 * 10**18);

        // Add new bikes
        bikeRegistration.registerBike("Bike1", 2014, false, "Aveiro school");
        bikeRegistration.registerBike("Bike2", 2018, true, "Lisbon school");

        // Approve allowance from renter1 for rentalAgreement
        /*vm.startPrank(renter1);
        usdt.approve(address(rentalAgreement), 30*10**18);    
        vm.stopPrank();*/
    }

    function testGasRentABike() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 30000;
        uint bikeId = 0;

        // Measure gas usage for renting a bike
        uint256 gasStart = gasleft();
        rentalAgreement.rentABike(amount, bikeId);
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for renting a bike:", gasUsed);

        vm.stopPrank();
    }

    function testGasReturnABike() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 4500000;
        uint bikeId = 1;

        // Rent a bike first
        rentalAgreement.rentABike(amount, bikeId);

        // Measure gas usage for returning a bike
        uint256 gasStart = gasleft();
        rentalAgreement.returnABike(0, serviceOwner, 1, "51.509865,-0.118092");
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for returning a bike:", gasUsed);

        vm.stopPrank();
    }

    // transaction throughput, time taken for a 15min trip scenario
    function testTransactionThroughput() public {
        vm.startPrank(owner);
        bikeRegistration.registerBike("Bike1", 2014, false, "Aveiro school");
        vm.stopPrank();

        vm.startPrank(renter1);
        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        uint256 startTime = block.timestamp;
        uint rentalId = 0;

        for (uint256 i = 0; i < 200; i++) {
            vm.startPrank(renter1);
            rentalAgreement.rentABike(1000, 0);
            rentalAgreement.returnABike(rentalId, owner, 0, "Lisbon office");
            vm.stopPrank();
            rentalId++;
        }

        uint256 endTime = block.timestamp;
        uint256 duration = endTime - startTime;
        emit log_named_uint("Time taken for 100 rent and return transactions (seconds)", duration);
        vm.stopPrank();
    }

    function testGasRent50Bikes() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 4500000;
        uint bikeId = 1;

        // Measure gas usage for renting two hundred bikes
        uint256 gasStart = gasleft();
        for (uint i = 1; i <= 50; i++) {
            rentalAgreement.rentABike(amount, bikeId);
        }
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for renting one hundred bikes:", gasUsed);

        vm.stopPrank();
    }

    function testGasRent100Bikes() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 4500000;
        uint bikeId = 1;

        // Measure gas usage for renting one hundred bikes
        uint256 gasStart = gasleft();
        for (uint i = 1; i <= 100; i++) {
            rentalAgreement.rentABike(amount, bikeId);
        }
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for renting one hundred bikes:", gasUsed);

        vm.stopPrank();
    }

    function testGasRent150Bikes() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 4500000;
        uint bikeId = 1;

        // Measure gas usage for renting two hundred bikes
        uint256 gasStart = gasleft();
        for (uint i = 1; i <= 150; i++) {
            rentalAgreement.rentABike(amount, bikeId);
        }
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for renting one hundred bikes:", gasUsed);

        vm.stopPrank();
    }

    function testGasRent200Bikes() public {
        vm.startPrank(renter1);

        // Approve USDT transfer for the rentalBike contract
        usdt.approve(address(rentalAgreement), 30*10**18);

        // Set up rentABike variables
        uint amount = 4500000;
        uint bikeId = 1;

        // Measure gas usage for renting two hundred bikes
        uint256 gasStart = gasleft();
        for (uint i = 1; i <= 200; i++) {
            rentalAgreement.rentABike(amount, bikeId);
        }
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for renting one hundred bikes:", gasUsed);

        vm.stopPrank();
    }
}