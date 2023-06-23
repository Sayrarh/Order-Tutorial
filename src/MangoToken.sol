//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MangoToken is ERC20 {
    constructor(address user) ERC20("Mango", "MNG") {
        _mint(user, 2000000 * 10 ** decimals());
    }
}
