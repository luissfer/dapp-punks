// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./CyberPunksDNA.sol";

contract CyberPunks is ERC721, ERC721Enumerable, CyberPunksDNA {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("CyberPunks", "CBRPKS") {
        maxSupply = _maxSupply;
    }

    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No CyberPunks left sorry");

        _safeMint(msg.sender, current);
        _idCounter.increment();
    }

    function _baseURI() 
        internal 
        pure 
        override 
        returns (string memory) {
        return "api-openai-format?";
    }

    function _paramsURI(uint256 _dna) 
        internal 
        view 
        returns (string memory) {
            string memory params;
            {
                params = string(
                    abi.encodePacked(
                        "inputdeluser=",
                        getInputText(_dna)
     //                   "&clotheColor=",
     //                   accessoriesType(_dna),
                    )
                );
            }

            return string(abi.encodePacked(params, "&getAccesoriesType=", getAccesoriesType(_dna)));
    }

    function imageByOpenAI(uint256 _dna) 
        public 
        view 
        returns (string memory) 
    {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    function tokenURI(uint256 tokenId) 
        public 
        view 
        override 
        returns (string memory) 
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByOpenAI(dna);

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "CyberPunks #',
                tokenId.toString(),
                '", "descritpion": "Cyber Punks smart contract", "image":"',
                image,
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }


    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}