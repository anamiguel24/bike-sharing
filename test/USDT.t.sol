// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {USDT} from "../src/USDT.sol";

contract USDTTest is Test {
    USDT usdt;

    function setUp() public {
        usdt = new USDT();
    }

   /* function test_Mint() public {
        //usdt.mint(address(this), 30 * 10 ** 18);
        assertEq(usdt.balanceOf(address(this)), 30 * 10 ** 18);
    } */

    function test_Transfer() public {
        //usdt.mint(address(this), 30 * 10 ** 18);
        usdt.transfer(address(this), 10 * 10 ** 18);
        usdt.transfer(address(0x123), 10 * 10 ** 18);
        assertEq(usdt.balanceOf(address(0x123)), 10 * 10 ** 18);
        assertEq(usdt.balanceOf(address(this)), 20 * 10 ** 18);
    }

    /*function test_TransferToZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(USDT.Transfer(address(0), address(0x123), 10 * 10 ** 18).selector));
        usdt.transfer(address(0), 10 * 10 ** 18);
    }

    function test_TransferFromZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(USDT.Transfer(address(this), address(0), 10 * 10 ** 18).selector));
        usdt.transfer(address(this), 10 * 10 ** 18);
    }*/
}