# Perpetual Futures Engine 📈

![Solidity](https://img.shields.io/badge/Solidity-0.8.20-black) ![DeFi](https://img.shields.io/badge/Financial-Derivatives-blue) ![Risk](https://img.shields.io/badge/Risk-High-red)

## Protocol Overview

This repository contains the smart contract logic for a decentralized perpetual futures exchange. Unlike AMMs (Automated Market Makers), this protocol uses a "Vault" model where Liquidity Providers (LPs) bet against traders.

### Key Mechanisms

1.  **Vault**: Stores the global liquidity (e.g., USDC). Traders deposit collateral here. LPs earn fees when traders lose, and pay out when traders win.
2.  **Leverage**: Traders can borrow funds from the Vault to amplify their position size (e.g., $100 Collateral * 10x = $1000 Position).
3.  **Liquidation**: If the collateral value drops below the `maintenanceMargin`, the position is closed by a "Keeper", and the remaining collateral is seized.

### Math & Safety
* **Entry Price**: Determined by Chainlink Oracles (Zero Slippage).
* **Funding Rate**: Mechanism to tether the perp price to the spot price.
* **PnL Calculation**: `(CurrentPrice - EntryPrice) * Size`.

## Deployment

1.  **Deploy Vault**: The bank of the protocol.
2.  **Deploy Router**: The user-facing logic for opening/closing trades.
3.  **Set Oracle**: Point to a valid Price Feed.

## Usage

```javascript
// Open a 5x Long Position on ETH
router.increasePosition(ETH_ADDRESS, collateralAmount, 5);
