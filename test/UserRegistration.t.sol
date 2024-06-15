// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {UserRegistration} from "../src/UserRegistration.sol";

// unit test
contract UserRegistrationTest is Test {
    UserRegistration userRegistration;

    function setUp() public {
        userRegistration = new UserRegistration();
    }

    function testRegisterUser() public {
        userRegistration.registerRenter(address(1), "Alice");
        uint numUsers = userRegistration.totalRenters();
        assertEq(numUsers, 1, "The number of registered users should be 1");
    }

    function testCannotRegisterExistingUser() public {
        userRegistration.registerRenter(address(2), "Alice");
        try userRegistration.registerRenter(address(2), "Alice") {
            revert("User already exists.");
        } catch Error(string memory error) {
            assertTrue(keccak256(bytes(error)) == keccak256(bytes("User already exists.")), "The correct error message should be displayed");
        }
    }

    function testGetUser() public {
        userRegistration.registerRenter(address(0), "Ana");
        (string memory name, bool canRent, uint balance, bool isRegistered, uint nTrips) = userRegistration.getRenterDetails(address(0));
        assertEq(name, "Ana", "The user's name should be Ana");
        assertTrue(canRent, "The user should be able to rent");
        assertEq(balance, 0, "The user's balance should be 0");
        assertTrue(isRegistered, "The user should be registered");
        assertEq(nTrips, 0, "The user's number of trips should be 0");
    }
}