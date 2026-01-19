const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    
    // 1. Mock USDC
    const USDC = await ethers.getContractFactory("MockToken"); // Assuming MockToken exists
    const usdc = await USDC.deploy("USD Coin", "USDC");
    
    // 2. Deploy Contracts
    const Oracle = await ethers.getContractFactory("PriceOracle");
    const oracle = await Oracle.deploy();
    
    const Vault = await ethers.getContractFactory("Vault");
    const vault = await Vault.deploy(usdc.address);

    const Router = await ethers.getContractFactory("Router");
    const router = await Router.deploy(vault.address, oracle.address);

    // 3. Setup Permissions
    await vault.transferOwnership(router.address); // Router controls the money

    console.log(`Router deployed: ${router.address}`);
    console.log(`Vault deployed: ${vault.address}`);
}

main().catch(console.error);
