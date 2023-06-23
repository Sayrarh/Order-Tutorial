// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Orderswap.sol";
import "../src/BananaToken.sol";
import "../src/MangoToken.sol";

contract OrderswapTest is Test {
    Orderswap public orderswap;
    BananaToken public bananatoken;
    MangoToken public mangotoken;

    address customer = mkaddr("customer"); //user comming to place order
    address executor = mkaddr("executor"); //user who is executing the order

    function setUp() public {
        orderswap = new Orderswap();
        bananatoken = new BananaToken(customer);
        mangotoken = new MangoToken(executor);
    }

    function testSwap() public {
        vm.startPrank(customer);
        ERC20(address(bananatoken)).approve(address(orderswap), 200e18);
        orderswap.placeOrder(
            address(bananatoken),
            address(mangotoken),
            200e18,
            210e18
        );
        vm.stopPrank();
        vm.startPrank(executor);
        ERC20(address(mangotoken)).approve(address(orderswap), 210e18);
        orderswap.executeOrder(1);
        vm.stopPrank;
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
