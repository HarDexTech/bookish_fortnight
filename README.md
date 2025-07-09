# Solana Arbitrage Development Environment

A complete development environment for building Solana arbitrage trading bots with pre-configured tools and dependencies.

## 🚀 Quick Start

### Option 1: GitHub Codespaces (Recommended)
1. Click "Code" → "Codespaces" → "Create codespace on main"
2. Wait for the environment to build (3-5 minutes)
3. Start coding immediately!

### Option 2: Local Development with VS Code
1. Clone this repository
2. Open in VS Code
3. Install the "Remote - Containers" extension
4. Press `F1` → "Remote-Containers: Open Folder in Container"
5. Wait for setup to complete

## 📦 What's Included

### Core Tools
- **Solana CLI** v2.2.20 - Official Solana command-line tools
- **Anchor Framework** v0.31.1 - Solana's development framework
- **Rust** v1.86 - System programming language
- **Node.js** v23.11.0 - JavaScript runtime
- **Yarn** v1.22.22 - Package manager

### Development Environment
- **VS Code Extensions** - Rust Analyzer, TypeScript, Prettier
- **Port Forwarding** - Pre-configured for common development ports
- **Volume Caching** - Faster builds with cached dependencies
- **Git Integration** - Ready for version control

### Project Structure
```
solana-arbitrage/
├── .devcontainer/
│   ├── devcontainer.json
│   └── setup.sh
├── programs/
│   └── solana-arbitrage/
│       └── src/
│           └── lib.rs
├── tests/
├── app/
├── scripts/
├── Anchor.toml
├── Cargo.toml
└── package.json
```

## 🛠️ Development Workflow

### 1. Start Local Validator
```bash
solana-test-validator
```

### 2. Build Your Program
```bash
anchor build
```

### 3. Deploy to Local Network
```bash
anchor deploy
```

### 4. Run Tests
```bash
anchor test
```

### 5. Start Frontend Development
```bash
npm run dev
```

## 🔧 Configuration

### Environment Variables
The setup includes a `.env` file with common configurations:

```env
# Solana Configuration
SOLANA_NETWORK=devnet
RPC_URL=https://api.devnet.solana.com

# Wallet Configuration
WALLET_PRIVATE_KEY_PATH=~/.config/solana/id.json

# Arbitrage Configuration
MIN_PROFIT_THRESHOLD=0.01
MAX_SLIPPAGE=0.5
GAS_LIMIT=1000000

# DEX Configuration
JUPITER_API_URL=https://quote-api.jup.ag
SERUM_PROGRAM_ID=9xQeWvG816bUx9EPjHmaT23yvVM2ZWbrrpZb9PusVFin
```

### Solana Networks
Switch between networks easily:
```bash
# Devnet (default)
solana config set --url devnet

# Mainnet
solana config set --url mainnet-beta

# Local
solana config set --url localhost
```

## 🏗️ Building Your Arbitrage Bot

### Key Components
1. **On-chain Program** (`programs/solana-arbitrage/src/lib.rs`)
   - Smart contract logic
   - Cross-program invocations
   - State management

2. **Off-chain Client** (`app/src/`)
   - Price monitoring
   - Opportunity detection
   - Transaction execution

3. **Testing Suite** (`tests/`)
   - Unit tests
   - Integration tests
   - Performance tests

### Common DEX Integrations
- **Jupiter Aggregator** - Best price routing
- **Serum DEX** - Order book trading
- **Raydium** - AMM liquidity pools
- **Orca** - Concentrated liquidity

## 📊 Available Scripts

| Command | Description |
|---------|-------------|
| `anchor build` | Compile Solana programs |
| `anchor deploy` | Deploy to configured network |
| `anchor test` | Run test suite |
| `npm run dev` | Start frontend development server |
| `npm run build` | Build production frontend |
| `npm start` | Start the arbitrage bot |
| `solana-test-validator` | Start local Solana validator |

## 🔍 Monitoring & Debugging

### Logs
```bash
# Solana logs
solana logs

# Anchor logs
anchor test --skip-build

# Custom logging
RUST_LOG=debug anchor test
```

### Common Debugging Commands
```bash
# Check account info
solana account <ACCOUNT_ADDRESS>

# Check program logs
solana logs <PROGRAM_ID>

# Validate transactions
solana confirm <TRANSACTION_SIGNATURE>
```

## 🚨 Troubleshooting

### Common Issues

**Issue: Solana CLI not found**
```bash
export PATH="/home/vscode/.local/share/solana/install/active_release/bin:$PATH"
source ~/.bashrc
```

**Issue: Anchor command not found**
```bash
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
avm use 0.31.1
```

**Issue: Node modules not found**
```bash
cd /workspace/solana-arbitrage/solana-arbitrage
npm install
```

**Issue: Rust compilation errors**
```bash
rustup update
cargo clean
anchor build
```

### Reset Environment
If something goes wrong, rebuild the container:
1. `F1` → "Remote-Containers: Rebuild Container"
2. Wait for setup to complete
3. All tools will be reinstalled fresh

## 🔐 Security Considerations

### Wallet Management
- Never commit private keys to git
- Use separate wallets for devnet/mainnet
- Implement proper key rotation

### Risk Management
- Set appropriate slippage limits
- Implement circuit breakers
- Monitor for MEV attacks

### Best Practices
- Test thoroughly on devnet first
- Use small amounts for initial mainnet testing
- Implement proper error handling
- Monitor gas consumption

## 📚 Resources

### Official Documentation
- [Solana Documentation](https://docs.solana.com/)
- [Anchor Book](https://book.anchor-lang.com/)
- [Solana Cookbook](https://solanacookbook.com/)

### DEX Documentation
- [Jupiter API](https://docs.jup.ag/)
- [Serum DEX](https://docs.projectserum.com/)
- [Raydium SDK](https://raydium.gitbook.io/)

### Community
- [Solana Discord](https://discord.com/invite/pquxPsq)
- [Anchor Discord](https://discord.gg/anchor)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/solana)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚡ Performance Tips

### Optimization Strategies
- Use account data caching
- Batch transactions when possible
- Optimize compute units usage
- Implement proper retry logic

### Monitoring
- Track transaction success rates
- Monitor latency and throughput
- Set up alerts for failures
- Log performance metrics

---

**Ready to start building?** 🚀

1. Open a terminal in the container
2. Run `solana-test-validator` in one terminal
3. Run `anchor test` in another terminal
4. Start coding your arbitrage strategy!

*Happy trading!* 💰
