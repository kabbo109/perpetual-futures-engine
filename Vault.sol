// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vault is Ownable {
    IERC20 public usdc;
    
    // Total liquidity provided by LPs
    uint256 public poolAmounts;
    
    // Reserved amounts for active trader positions
    uint256 public reservedAmounts;

    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }

    // LPs deposit stablecoin to earn fees
    function addLiquidity(uint256 _amount) external {
        usdc.transferFrom(msg.sender, address(this), _amount);
        poolAmounts += _amount;
    }

    // Called by Router when a trader opens a position
    function reserveFunds(uint256 _size) external onlyOwner {
        require(poolAmounts >= reservedAmounts + _size, "Not enough liquidity");
        reservedAmounts += _size;
    }

    // Called when a trader closes a winning position
    function payout(address _to, uint256 _amount) external onlyOwner {
        require(usdc.balanceOf(address(this)) >= _amount, "Vault insolvent");
        usdc.transfer(_to, _amount);
        reservedAmounts -= _amount; // Simplified logic
    }
}
