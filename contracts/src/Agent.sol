// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {Platform} from "./PlatformType.sol";

/// @title Agent Contract
/// @notice This contract represents an individual trading agent that can execute trades based on authorized signatures
/// @dev Implements ReentrancyGuard for security against reentrancy attacks
contract Agent is ReentrancyGuard {
    using ECDSA for bytes32;

    error Agent__NotOwner();
    error Agent__AlreadyPaused();
    error Agent__AlreadyRunning();
    error Agent__WithdrawalFailed();
    error Agent__DeadlinePassed();
    error Agent__NonceAlreadyUsed();
    error Agent__IncorrectSignature();
    error Agent__IncorrectSignatureLength();
    error Agent__InvalidTokens();
    error Agent__InsufficientBalance();
    error Agent__NotAuthorized();

    /// @notice Structure to hold trade data for execution
    /// @param tokenIn Address of the input token
    /// @param tokenOut Address of the output token
    /// @param amountIn Amount of input token to trade
    /// @param minAmountOut Minimum amount of output token expected
    /// @param maxAmountOut Maximum amount of output token expected
    /// @param deadline Timestamp after which the trade becomes invalid
    /// @param nonce Unique identifier to prevent replay attacks
    struct TradeData {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 minAmountOut; // based on low price
        uint256 maxAmountOut; // based on high price
        uint256 deadline;
        uint256 nonce;
    }

    mapping(uint256 nonce => bool) noncesUsed;
    /// @notice Mapping to track which tokens are supported by this agent
    mapping(address token => bool) public tokensPresent;

    /// @notice The platform type this agent is associated with
    Platform public platformType;

    /// @notice The owner address of this agent
    address owner; // address of the user

    /// @notice Flag indicating if the agent is paused
    bool public isPaused;

    /// @notice The authorized signer address that can execute trades
    address immutable authorizedSigner; // address of the psuedo wallet created for the backend which will execute the swap function

    string private constant name = "Agent";
    string private constant version = "1";
    uint256 immutable chainId;
    address immutable verifyingContract;

    bytes32 private constant DOMAIN_HASH =
        keccak256(
            "EIP712Domain(string name, string version, uint256 chainId, address verifyingContract)"
        );
    bytes32 private DOMAIN_SEPARATOR;

    bytes32 private constant TYPE_HASH =
        keccak256(
            "TradeData(address tokenIn, address tokenOut, uint256 amountIn, uint256 minAmountOut, uint256 maxAmountOut, uint256 deadline, uint256 nonce)"
        );

    event Agent__AgentPaused();
    event Agent__AgentRestarted();
    event Agent__FundsWithdrawan(address indexed user, uint256 amountWithdrawn);
    event Agent__TradeExecuted(
        address indexed user,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn
    );

    modifier onlyOwner() {
        if (owner != msg.sender) {
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

    modifier onlyAuthorized() {
        if (msg.sender != authorizedSigner) {
            revert Agent__NotAuthorized();
        }
        _;
    }

    constructor(
        address[] memory _tokens,
        Platform _platformType,
        address _authorizedSigner,
        address _owner
    ) payable {
        for (uint256 i = 0; i < _tokens.length; i++) {
            tokensPresent[_tokens[i]] = true;
        }
        platformType = _platformType;
        owner = _owner;
        authorizedSigner = _authorizedSigner;
        chainId = block.chainid;
        verifyingContract = address(this);
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                DOMAIN_HASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );
    }

    /// @notice Pauses the agent, preventing any new trades
    /// @dev Only callable by the owner
    function pauseAgent() external onlyOwner {
        if (isPaused == true) {
            revert Agent__AlreadyPaused();
        }
        isPaused = true;
        emit Agent__AgentPaused();
    }

    /// @notice Resumes the agent, allowing new trades
    /// @dev Only callable by the owner
    function resumeAgent() external onlyOwner {
        if (isPaused == false) {
            revert Agent__AlreadyRunning();
        }
        isPaused = false;
        emit Agent__AgentRestarted();
    }

    /// @notice Withdraws all funds from the agent to the owner
    /// @dev Only callable when agent is paused and by the owner
    function withdrawFunds() external paused nonReentrant onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner).call{value: balance}("");
        if (success != true) {
            revert Agent__WithdrawalFailed();
        }
        emit Agent__FundsWithdrawan(msg.sender, balance);
    }

    function hashTradeData(
        TradeData memory data
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    TYPE_HASH,
                    data.tokenIn,
                    data.tokenOut,
                    data.amountIn,
                    data.minAmountOut,
                    data.maxAmountOut,
                    data.deadline,
                    data.nonce
                )
            );
    }

    function verifySignature(
        TradeData memory data,
        bytes calldata signature
    ) internal view returns (bool) {
        bytes32 digest = calculateDigest(data);
        address signer = digest.recover(signature);
        return signer == authorizedSigner;
    }

    function calculateDigest(
        TradeData memory data
    ) internal view returns (bytes32) {
        return
            keccak256(
                abi.encode("\x19\x01", DOMAIN_SEPARATOR, hashTradeData(data))
            );
    }

    function executeSwap(
        TradeData memory data,
        bytes calldata signature
    ) external nonReentrant onlyAuthorized {
        if (block.timestamp > data.deadline) {
            revert Agent__DeadlinePassed();
        }
        if (noncesUsed[data.nonce] == true) {
            revert Agent__NonceAlreadyUsed();
        }

        if (signature.length != 65) {
            revert Agent__IncorrectSignatureLength();
        }

        if (
            tokensPresent[data.tokenIn] == false ||
            tokensPresent[data.tokenOut] == false
        ) {
            revert Agent__InvalidTokens();
        }

        if (data.amountIn > address(this).balance) {
            revert Agent__InsufficientBalance();
        }

        bool valid = verifySignature(data, signature);
        if (!valid) {
            revert Agent__IncorrectSignature();
        }

        noncesUsed[data.nonce] = true;

        emit Agent__TradeExecuted(
            msg.sender,
            data.tokenIn,
            data.tokenOut,
            data.amountIn
        );
    }

    /// @notice Returns the current balance of the agent
    /// @return The current balance in wei
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Returns the authorized signer address
    /// @return The address of the authorized signer
    function getAuthorizedSigner() external view returns (address) {
        return authorizedSigner;
    }

    function isNonceUsed(uint256 nonce) external view returns (bool) {
        return noncesUsed[nonce];
    }

    function getDomainSeparator() external view returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }
}
