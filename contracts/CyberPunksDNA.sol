// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CyberPunksDNA {
    string[] private _accessoriesType = [
        "Blank",
        "Kurt",
        "Prescription01",
        "Prescription02",
        "Round",
        "Sunglasses",
        "Wayfarers"
    ];

    string[] private _inputText = [
        "//TODO GET TEXT FROM JS"
    ];


    // Get attributes
    uint8 constant ADN_SECTION_SIZE = 2;

    function _getDNASection(uint256 _dna, uint8 _rightDiscard)
        internal
        pure
        returns (uint8)
    {
        return
            uint8(
                (_dna % (1 * 10**(_rightDiscard + ADN_SECTION_SIZE))) /
                    (1 * 10**_rightDiscard)
            );
    }

    function getAccesoriesType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint8 dnaSection = _getDNASection(_dna, 0);
        return _accessoriesType[dnaSection % _accessoriesType.length];
    }

    function getInputText(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint8 dnaSection = _getDNASection(_dna, 2);
        return _accessoriesType[dnaSection % _accessoriesType.length];
    }

}