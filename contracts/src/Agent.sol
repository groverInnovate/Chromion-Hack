// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Agent {
    error Agent__LengthNotSame();

    string[] tokens;
    string platformType;

    constructor(string[] memory _tokens, string memory _platformType) {
        if (tokens.length != _tokens.length) {
            revert Agent__LengthNotSame();
        }
        for (uint256 i = 0; i < tokens.length; i++) {
            tokens[i] = _tokens[i];
        }
        platformType = _platformType;
    }

    function getPlatform() external view returns (string memory) {
        return platformType;
    }

    function getTokens() external view returns (string[] memory) {
        return tokens;
    }
}
