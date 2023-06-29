const deploy = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with the account:", deployer.address);
  const CyberPunks = await ethers.getContractFactory("CyberPunks");
  const deployed = await CyberPunks.deploy(1000);
  console.log("CyberPunks is deployed at:", deployed.address)
};

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
