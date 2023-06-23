//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MangoToken is ERC20 {
    address owner;

    constructor() ERC20("Mango", "MNG") {
        owner = msg.sender;
        _mint(address(this), 2000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "Not owner");
        _mint(to, amount);
    }
}
