//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

/**
 @title Lottery
 */
contract Lottery {
    address[] public players;
    address[] public gameWinners;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY_OWNER");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // declaring the receive() function that is necessary to receive ETH
    receive() external payable {
        require(msg.value == 0.1 ether, "INSUFFICIENT_VALUE");
        players.push(msg.sender);
    }

    // returning the contract's balance in wei
    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // select the winner of the lottery
    function pickWinner() public onlyOwner {
        require(players.length >= 3, "NOT_ENOUGH_PLAYERS");

        uint256 randomIndex = random() % players.length;
        address winner = players[randomIndex];

        gameWinners.push(winner);
        delete players;

        (bool success, ) = winner.call{value: address(this).balance}("");
        require(success, "TRANSFER_FAILED");
    }

    // helper function that returns a big random integer
    // UNSAFE! Don't trust random numbers generated on-chain, they can be exploited! This method is used here for simplicity
    // See: https://solidity-by-example.org/hacks/randomness
    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }
}
