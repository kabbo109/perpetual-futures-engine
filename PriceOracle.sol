// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

// Mock Oracle for Development (In Prod, use Chainlink AggregatorV3)
contract PriceOracle is Ownable {
    mapping(address => uint256) public prices;

    function setPrice(address _token, uint256 _price) external onlyOwner {
        prices[_token] = _price;
    }

    function getPrice(address _token) external view returns (uint256) {
        return prices[_token];
    }
}
