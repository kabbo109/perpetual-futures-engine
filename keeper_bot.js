const { ethers } = require("hardhat");
const { ROUTER_ADDRESS } = require("./config");

async function main() {
    const router = await ethers.getContractAt("Router", ROUTER_ADDRESS);
    
    // In reality, we loop through all active positions from a Graph/Subgraph
    const targetUser = "0xUserAddress...";
    const targetToken = "0xEthAddress...";

    try {
        console.log("Checking for liquidation...");
        const tx = await router.liquidatePosition(targetUser, targetToken);
        console.log(`LIQUIDATION EXECUTED: ${tx.hash}`);
    } catch (e) {
        console.log("Position is safe (or error occured).");
    }
}

main();
