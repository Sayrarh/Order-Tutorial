// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Orderswap {
    event OrderPlaced(
        address user,
        address tokenFrom,
        address tokenTo,
        uint256 amountIn,
        uint256 amountOut
    );
    event OrderExecuted(
        address tokenFrom,
        address tokenTo,
        address executor,
        uint256 amountIn,
        uint256 amountOut
    );

    enum Status {
        booked,
        completed
    }

    struct OrderDetails {
        address user;
        address tokenFrom;
        address tokenTo;
        uint256 amountIN;
        uint256 amountOUT;
        Status orderStatus;
    }

    uint256 ID = 1;
    mapping(uint256 => OrderDetails) _orderdetails;

    error InvalidOrderID();

    function placeOrder(
        address _tokenFrom,
        address _tokenTo,
        uint256 _amountIN,
        uint256 _amountOUT
    ) external {
        assert(
            ERC20(_tokenFrom).transferFrom(msg.sender, address(this), _amountIN)
        );

        OrderDetails storage OD = _orderdetails[ID];
        OD.user = msg.sender;
        OD.tokenFrom = _tokenFrom;
        OD.tokenTo = _tokenTo;
        OD.amountIN = _amountIN;
        OD.amountOUT = _amountOUT;
        OD.orderStatus = Status.booked;

        ID++;
        emit OrderPlaced(
            msg.sender,
            _tokenFrom,
            _tokenTo,
            _amountIN,
            _amountOUT
        );
    }

    function executeOrder(uint256 customerID) external {
        OrderDetails storage OD = _orderdetails[customerID];
        if (customerID > ID || customerID == 0) revert InvalidOrderID();

        uint256 amount = OD.amountOUT;
        address token = OD.tokenTo;

        assert(ERC20(token).transferFrom(msg.sender, address(this), amount));

        ERC20(OD.tokenFrom).transfer(msg.sender, OD.amountIN);
        ERC20(token).transfer(OD.user, amount);
        OD.orderStatus = Status.completed;

        assert(ERC20(OD.tokenFrom).balanceOf(msg.sender) >= OD.amountIN);
        assert(ERC20(OD.tokenTo).balanceOf(OD.user) >= amount);

        emit OrderExecuted(
            OD.tokenFrom,
            OD.tokenTo,
            msg.sender,
            OD.amountIN,
            amount
        );
    }

    function getSwapDetails(
        uint256 _ID
    ) external view returns (OrderDetails memory) {
        if (_ID > ID || _ID == 0) revert InvalidOrderID();

        OrderDetails memory OD = _orderdetails[_ID];
        return OD;
    }
}
