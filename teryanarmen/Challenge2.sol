// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
// fix
import "@openzeppelin/contracts/utils/Address.sol";

interface ICalled {
    function sup() external returns (uint256);
}

contract Challenge2 {
    using Address for address;

    State public state;
    address public winner;

    modifier onlyWinner() {
        require(msg.sender == winner, "oops");
        _;
    }
    modifier onlyState(State _state) {
        require(state == _state, "no...");
        _;
    }
    modifier onlyContract() {
        require(Address.isContract(msg.sender), "try again");
        _;
    }
    modifier onlyNotContract() {
        require(!Address.isContract(msg.sender), "yeah, no");
        _;
    }

    enum State {
        ZERO,
        ONE,
        TWO,
        THREE
    }

    constructor() payable {
        require(msg.value == 1 ether, "cheap");
    }

    function first() public onlyNotContract onlyState(State.ZERO) {
        winner = msg.sender;
        state = State.ONE;
    }

    function second() public onlyWinner onlyContract onlyState(State.ONE) {
        require(ICalled(msg.sender).sup() == 1337, "not leet");
        state = State.TWO;
    }

    function third() public onlyWinner onlyNotContract onlyState(State.TWO) {
        state = State.THREE;
    }

    function fourth() public onlyWinner onlyContract onlyState(State.THREE) {
        require(ICalled(msg.sender).sup() == 80085, "not boobs");
        msg.sender.transfer(address(this).balance);
    }
}
