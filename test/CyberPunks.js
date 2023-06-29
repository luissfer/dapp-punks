const { expect } = require("chai");

describe('CyberPunks Contract', () => {
    const setup = async ({ maxSupply = 10000 }) => {
        const [owner] = await ethers.getSigners();
        const CyberPunks = await ethers.getContractFactory("CyberPunks");
        const deployed = await CyberPunks.deploy(maxSupply);

        return {
            owner,
            deployed,
        };
    };
    describe('Deployment', () => {
        it('Sets max supply to passed pams', async () => {
            const maxSupply = 4000;

            const { deployed } = await setup({maxSupply});

            const returnedMaxSupply = await deployed.maxSupply();

            expect(maxSupply).to.equal(returnedMaxSupply)
        });
    });

    describe('Minting', () => {
        it('Mint a new token and assigns it to owner', async () => {
            const { owner, deployed } = await setup({});
            await deployed.mint();

            const ownerOfMinted = await deployed.ownerOf(0);

            expect(ownerOfMinted).to.equal(owner.address);
        });

        it('Has a minting limit', async () => {
            const maxSupply = 3;
            const { deployed } = await setup({maxSupply});

            await deployed.mint();
            await deployed.mint();
            await deployed.mint();

            await expect(deployed.mint()).to.be.revertedWith("No CyberPunks left sorry");
        });
    });

    describe('tokenURI', () => {
        it('Returns valid metadata', async () => {
            const { deployed } = await setup({});
            await deployed.mint();

            const tokenURI = await deployed.tokenURI(0);
            const stringifiedTokenURI = await tokenURI.toString();
            const [prefix, base64JSON] = stringifiedTokenURI.split(
                "data:application/json;base64,"
            );
            const stringifiedMetadata = await Buffer.from(
                base64JSON, 
                "base64"
            ).toString('ascii');

            const metadata = JSON.parse(stringifiedMetadata);

            expect(metadata).to.have.all.keys("name", "description");
                
        });
    });



});