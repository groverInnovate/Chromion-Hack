# Trading Agent System

This system consists of two main smart contracts that work together to create and manage automated trading agents across different social media platforms.

## Overview

The system allows users to create trading agents that can execute trades based on signals from different social media platforms (Twitter, Telegram, or Discord). Each agent is a separate contract instance that can be paused, resumed, and managed by its owner.

## Contracts

### AgentFactory

The factory contract is responsible for:
- Creating new trading agent instances
- Maintaining a registry of all created agents
- Validating platform types and initial parameters
- Tracking agent ownership and investments

### Agent

The agent contract represents an individual trading instance that:
- Manages funds for trading
- Supports multiple tokens for trading
- Can be paused and resumed by the owner
- Implements security features like reentrancy protection
- Allows fund withdrawal when paused
- Supports authorized trading through signatures

## Key Features

1. **Multi-Platform Support**
   - Twitter
   - Telegram
   - Discord

2. **Security Features**
   - Reentrancy protection
   - Owner-only controls
   - Pausable functionality
   - Authorized trading through signatures

3. **Fund Management**
   - Initial investment tracking
   - Balance checking
   - Secure withdrawal mechanism

4. **Token Management**
   - Support for multiple tokens
   - Token validation
   - Trading parameter controls

## Usage

1. Users create a new agent through the factory by:
   - Specifying supported tokens
   - Choosing a platform type
   - Providing an authorized signer address
   - Sending initial investment

2. The agent can then:
   - Execute trades based on authorized signatures
   - Be paused/resumed by the owner
   - Withdraw funds when paused
   - Track supported tokens and balances

## Security Considerations

- All critical functions are protected by appropriate modifiers
- Reentrancy protection is implemented
- Owner-only controls for sensitive operations
- Pausable functionality for emergency situations
- Signature-based authorization for trades