//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 

contract USDT is ERC20 {
    constructor() ERC20 ("USDTToken", "USDT"){
        _mint(msg.sender, 30*10**18);
    }

    /*constructor(address ad) ERC20 ("USDTToken", "USDT"){
        _mint(ad, 30*10**18);
    }
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }*/

    // Function to mint new tokens, only callable by the owner
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

}