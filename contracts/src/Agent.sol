// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/*//////////////////////////////////////////////////////////////
                           IMPORTS
//////////////////////////////////////////////////////////////*/
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {Platform} from "./PlatformType.sol";

contract Agent is ReentrancyGuard {
    using ECDSA for bytes32;

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error Agent__NotOwner();
    error Agent__AgentIsPaused();
    error Agent__AgentIsRunning();
    error Agent__WithdrawalFailed();
    error Agent__DeadlinePassed();
    error Agent__NonceAlreadyUsed();
    error Agent__IncorrectSignature();
    error Agent__IncorrectSignatureLength();
    error Agent__InvalidTokens();
    error Agent__NotAuthorized();
    error Agent__AmountIsZero();

    /*//////////////////////////////////////////////////////////////
                              TYPE VARIABLES
    //////////////////////////////////////////////////////////////*/
    struct TradeData {
        address tokenIn;
        address tokenOut;
        uint256 amountIn;
        uint256 minAmountOut; // based on high price
        uint256 maxAmountOut; // based on low price
        uint256 deadline;
        uint256 nonce;
    }

    /*//////////////////////////////////////////////////////////////
                                MAPPING
    //////////////////////////////////////////////////////////////*/
    mapping(uint256 nonce => bool) noncesUsed;
    mapping(address token => bool) public tokensPresent;

    /*//////////////////////////////////////////////////////////////
                              STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    Platform private platformType;
    address private owner; // address of the user
    bool private isPaused;
    uint256 userFunds;
    address private immutable authorizedSigner; // address of the psuedo wallet created for the backend which will execute the swap function
    string private constant name = "Agent";
    string private constant version = "1";
    uint256 immutable chainId;
    address private immutable verifyingContract;
    bytes32 private constant EIP712_DOMAIN_TYPEHASH =
        keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );
    bytes32 private immutable DOMAIN_SEPARATOR;
    bytes32 private constant TYPE_HASH =
        keccak256(
            "TradeData(address tokenIn,address tokenOut,uint256 amountIn,uint256 minAmountOut,uint256 maxAmountOut,uint256 deadline,uint256 nonce)"
        );

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event Agent__AgentPaused();
    event Agent__AgentResumed();
    event Agent__FundsWithdrawan(address indexed user, uint256 amountWithdrawn);
    event Agent__FundsAdded(address indexed user, uint256 amountAdded);
    event Agent__TradeExecuted(
        address indexed user,
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn
    );

    /*//////////////////////////////////////////////////////////////
                                MODIFIERS
    //////////////////////////////////////////////////////////////*/
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert Agent__NotOwner();
        }
        _;
    }

    modifier paused() {
        if (!isPaused) {
            revert Agent__AgentIsRunning();
        }
        _;
    }

    modifier onlyAuthorized() {
        if (msg.sender != authorizedSigner) {
            revert Agent__NotAuthorized();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
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
        userFunds = msg.value;
        chainId = block.chainid;
        verifyingContract = address(this);
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );
    }

    /*//////////////////////////////////////////////////////////////
                           PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function pauseAgent() public onlyOwner {
        if (isPaused) {
            revert Agent__AgentIsPaused();
        }
        isPaused = true;
        emit Agent__AgentPaused();
    }

    function resumeAgent() public onlyOwner {
        if (!isPaused) {
            revert Agent__AgentIsRunning();
        }
        isPaused = false;
        emit Agent__AgentResumed();
    }

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function withdrawFunds() external nonReentrant onlyOwner {
        pauseAgent();
        _withdrawFunds();
        resumeAgent();
    }

    function addFunds() external payable nonReentrant onlyOwner {
        if (msg.value == 0) {
            revert Agent__AmountIsZero();
        }
        pauseAgent();
        _addFunds(msg.value);
        resumeAgent();
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

        bool valid = verifySignature(data, signature);
        if (!valid) {
            revert Agent__IncorrectSignature();
        }

        // swapping logic due

        noncesUsed[data.nonce] = true;

        emit Agent__TradeExecuted(
            msg.sender,
            data.tokenIn,
            data.tokenOut,
            data.amountIn
        );
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function _withdrawFunds() internal {
        uint256 balance = userFunds;
        (bool success, ) = payable(owner).call{value: balance}("");
        if (success != true) {
            revert Agent__WithdrawalFailed();
        }
        userFunds = 0;
        emit Agent__FundsWithdrawan(msg.sender, balance);
    }

    function _addFunds(uint256 amount) internal {
        userFunds = userFunds + amount;
        emit Agent__FundsAdded(msg.sender, amount);
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
                abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashTradeData(data))
            );
    }

    /*//////////////////////////////////////////////////////////////
                           GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAuthorizedSigner() external view returns (address) {
        return authorizedSigner;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function getUserFunds() external view returns (uint256) {
        return userFunds;
    }

    function isNonceUsed(uint256 nonce) external view returns (bool) {
        return noncesUsed[nonce];
    }

    function getPausedState() external view returns (bool) {
        return isPaused;
    }

    function getDomainSeparator() external view returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }
}
