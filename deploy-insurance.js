const hre = require("hardhat");

async function main() {
  const RAINFALL_ORACLE = "0x..."; // Chainlink Rainfall/Weather Feed
  
  const Insurance = await hre.ethers.getContractFactory("WeatherInsurance");
  const insurance = await Insurance.deploy(RAINFALL_ORACLE);

  await insurance.waitForDeployment();
  console.log("Weather Insurance deployed to:", await insurance.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
