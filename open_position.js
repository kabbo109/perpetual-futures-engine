const { ethers } = require("hardhat");
const { ROUTER_ADDRESS, USDC_ADDRESS, ETH_ADDRESS } = require("./config");

async function main() {
    const router = await ethers.getContractAt("Router", ROUTER_ADDRESS);
    const usdc = await ethers.getContractAt("IERC20", USDC_ADDRESS);

    const collateral = ethers.utils.parseUnits("100", 6); // 100 USDC
    const leverage = 10; // 10x

    // Approve Router to spend USDC
    await usdc.approve(ROUTER_ADDRESS, collateral);

    console.log("Opening 10x Long on ETH...");
    
    const tx = await router.increasePosition(ETH_ADDRESS, collateral, leverage);
    await tx.wait();
    
    console.log("Position Opened Successfully!");
}

main();
