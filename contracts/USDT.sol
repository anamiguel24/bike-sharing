//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./token/ERC20.sol"; 

contract USDT is ERC20 {
    constructor() ERC20 ("USDTToken", "USDT"){
        _mint(msg.sender, 30*10**18);
    }
}