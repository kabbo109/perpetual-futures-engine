// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Vault.sol";
import "./PriceOracle.sol";

contract Router {
    Vault public vault;
    PriceOracle public oracle;
    
    struct Position {
        uint256 size;       // Total size in USD (Collateral x Leverage)
        uint256 collateral; // User's margin
        uint256 entryPrice;
        bool isLong;
    }

    // User -> Token -> Position
    mapping(address => mapping(address => Position)) public positions;

    constructor(address _vault, address _oracle) {
        vault = Vault(_vault);
        oracle = PriceOracle(_oracle);
    }

    function increasePosition(address _indexToken, uint256 _collateral, uint256 _leverage) external {
        require(_leverage <= 50, "Max 50x leverage");
        
        uint256 size = _collateral * _leverage;
        uint256 price = oracle.getPrice(_indexToken);

        // Transfer collateral to Vault
        vault.usdc().transferFrom(msg.sender, address(vault), _collateral);
        
        // Reserve liquidity for this bet
        vault.reserveFunds(size);

        // Store Position
        Position storage pos = positions[msg.sender][_indexToken];
        pos.size += size;
        pos.collateral += _collateral;
        pos.entryPrice = price;
        pos.isLong = true;
    }

    function liquidatePosition(address _trader, address _indexToken) external {
        Position memory pos = positions[_trader][_indexToken];
        uint256 price = oracle.getPrice(_indexToken);
        
        // Simplified PnL: If price drops 10%, and leverage is 10x, user is REKT.
        // Real logic involves finding the delta and checking maintenance margin.
        
        bool isLiquidatable = false; // Logic omitted for brevity
        
        if (price < pos.entryPrice) {
             uint256 loss = (pos.entryPrice - price) * pos.size / pos.entryPrice;
             if (loss >= pos.collateral) {
                 isLiquidatable = true;
             }
        }

        require(isLiquidatable, "Position healthy");
        
        delete positions[_trader][_indexToken];
        // Keeper gets a reward fee here
    }
}
