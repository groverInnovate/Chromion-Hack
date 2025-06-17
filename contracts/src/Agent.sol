// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Agent {
    error Agent__LengthCannotBeZero();
    error Agent__NotOwner();
    error Agent__AlreadyPaused();
    error Agent__AlreadyRunning();
    error Agent__WithdrawalFailed();

    event Agent__AgentPaused();
    event Agent__AgentRestarted();
    event Agent__FundsWithdrawan();
    event Agent__TokensUpdated();

    string[] tokens;
    string platformType;
    address owner;
    bool isPaused;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Agent__NotOwner();
        }
        _;
    }

    modifier paused() {
        if (isPaused == false) {
            revert Agent__AlreadyRunning();
        }
        _;
    }

    constructor(string[] memory _tokens, string memory _platformType) payable {
        if (_tokens.length == 0) {
            revert Agent__LengthCannotBeZero();
        }
        tokens = _tokens;
        platformType = _platformType;
    }

    function pauseAgent() external onlyOwner {
        if (isPaused == true) {
            revert Agent__AlreadyPaused();
        }
        isPaused = true;
        emit Agent__AgentPaused();
    }

    function resumeAgent() external onlyOwner {
        if (isPaused == false) {
            revert Agent__AlreadyRunning();
        }
        isPaused = false;
        emit Agent__AgentRestarted();
    }

    function withdrawFunds() external paused {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner).call{value: balance}("");
        if (success != false) {
            revert Agent__WithdrawalFailed();
        }
        emit Agent__FundsWithdrawan();
    }

    function updateTokens(string[] memory _tokens) external paused {
        delete tokens;
        tokens = _tokens;
        emit Agent__TokensUpdated();
    } 
    
    function getPlatform() external view returns (string memory) {
        return platformType;
    }

    function getTokens() external view returns (string[] memory) {
        return tokens;
    }

    function getPauseStatus() external view returns(bool) {
        return isPaused;
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

}
