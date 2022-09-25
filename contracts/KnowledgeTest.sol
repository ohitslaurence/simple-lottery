//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract KnowledgeTest {
    string[] public tokens = ["BTC", "ETH"];
    address[] public players;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function transferAll(address account) external {
        require(msg.sender == owner, "ONLY_OWNER");
        (bool result, ) = account.call{value: address(this).balance}("");
        require(result, "TRANSFER_FAILED");
    }

    function start() external {
        players.push(msg.sender);
    }

    function concatenate(string calldata string1, string calldata string2)
        external
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(string1, string2));
    }

    function changeTokens() external {
        string[] storage t = tokens;
        t[0] = "VET";
    }

    receive() external payable {}
}
