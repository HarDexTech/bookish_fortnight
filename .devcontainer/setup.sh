#!/bin/bash

# Solana Arbitrage Bot Setup Script for GitHub Codespaces
echo "🚀 Setting up Solana Arbitrage Bot environment..."
echo "📋 Installing versions:"
echo "   - Rust: 1.86.0"
echo "   - Solana CLI: 2.2.12"
echo "   - Anchor CLI: 0.31.1"
echo "   - Node.js: 23.11.0"
echo "   - NPM: 10.9.0"
echo ""

# Update system packages
echo "🔄 Updating system packages..."
sudo apt-get update
sudo apt-get install -y build-essential pkg-config libudev-dev llvm libclang-dev curl wget git

# Install Rust 1.86.0
echo "🦀 Installing Rust 1.86.0..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.86.0
source ~/.cargo/env

# Verify Rust installation
echo "✅ Rust version: $(rustc --version)"
echo "✅ Cargo version: $(cargo --version)"

# Install Node.js 23.11.0 using NodeSource
echo "📦 Installing Node.js 23.11.0..."
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Node.js installation
echo "✅ Node.js version: $(node --version)"
echo "✅ NPM version: $(npm --version)"

# Install Solana CLI 2.2.12
echo "⚡ Installing Solana CLI 2.2.12..."
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

# Add Solana to PATH
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# Verify Solana installation
echo "✅ Solana CLI version: $(solana --version)"

# Install Anchor CLI 0.31.1 using AVM (Anchor Version Manager)
echo "⚓ Installing Anchor CLI 0.31.1..."
cargo install --git https://github.com/coral-xyz/anchor avm --force
export PATH="$HOME/.cargo/bin:$PATH"

# Install and use Anchor 0.31.1
avm install 0.31.1
avm use 0.31.1

# Verify Anchor installation
echo "✅ Anchor CLI version: $(anchor --version)"

# Create Solana config directory
mkdir -p ~/.config/solana

# Generate a new keypair if it doesn't exist
if [ ! -f ~/.config/solana/id.json ]; then
    echo "🔑 Generating new Solana keypair..."
    solana-keygen new --no-bip39-passphrase --silent --outfile ~/.config/solana/id.json
fi

# Set the keypair as default
solana config set --keypair ~/.config/solana/id.json

# Display wallet address
echo "💳 Wallet Address: $(solana address)"

# Request airdrop for testing
echo "💰 Requesting SOL airdrop..."
solana airdrop 2 || echo "Airdrop failed, you may need to request manually"

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Install additional development dependencies
npm install -D nodemon typescript @types/node

# Install Solana Web3.js and related packages
npm install @solana/web3.js @solana/spl-token @project-serum/anchor @solana/buffer-layout

# Install arbitrage-related dependencies
npm install axios dotenv ws bn.js

# Install Jupiter SDK for DEX aggregation
npm install @jup-ag/core @jup-ag/react-hook

# Create basic project structure
mkdir -p src/{utils,config,strategies,exchanges}
mkdir -p tests

# Create environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "🔧 Creating environment configuration..."
    cat > .env << EOF
# Solana Configuration
SOLANA_RPC_URL=https://api.devnet.solana.com
SOLANA_WS_URL=wss://api.devnet.solana.com
KEYPAIR_PATH=/home/node/.config/solana/id.json

# Trading Configuration
MIN_PROFIT_THRESHOLD=0.01
MAX_SLIPPAGE=0.005
TRADE_AMOUNT=0.1

# DEX Configuration
JUPITER_API_URL=https://quote-api.jup.ag/v6
RAYDIUM_API_URL=https://api.raydium.io/v2

# Monitoring
LOG_LEVEL=info
ENABLE_WEBHOOK=false
EOF
fi

# Create basic package.json if it doesn't exist
if [ ! -f package.json ]; then
    echo "📋 Creating package.json..."
    cat > package.json << EOF
{
  "name": "solana-arbitrage-bot",
  "version": "1.0.0",
  "description": "Advanced Solana arbitrage trading bot",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest",
    "build": "tsc",
    "lint": "eslint src/**/*.js",
    "monitor": "node src/monitor.js"
  },
  "keywords": ["solana", "arbitrage", "trading", "defi", "bot"],
  "author": "Your Name",
  "license": "MIT",
  "dependencies": {
    "@solana/web3.js": "^1.87.6",
    "@solana/spl-token": "^0.3.9",
    "@project-serum/anchor": "^0.28.0",
    "@solana/buffer-layout": "^4.0.1",
    "@jup-ag/core": "^4.0.0",
    "@jup-ag/react-hook": "^4.0.0",
    "axios": "^1.6.0",
    "dotenv": "^16.3.1",
    "ws": "^8.14.2",
    "bn.js": "^5.2.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "typescript": "^5.2.2",
    "@types/node": "^20.8.0",
    "jest": "^29.7.0",
    "eslint": "^8.51.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF
fi

# Create basic gitignore
if [ ! -f .gitignore ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs
*.log

# Solana keypairs (keep secure!)
*.json
!package.json
!tsconfig.json

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Build output
dist/
build/
target/

# Test coverage
coverage/
.nyc_output/

# Temporary files
*.tmp
*.temp
EOF
fi

# Create initial bot structure
if [ ! -f src/index.js ]; then
    echo "🤖 Creating basic bot structure..."
    cat > src/index.js << 'EOF'
const { Connection, PublicKey, Keypair } = require('@solana/web3.js');
const fs = require('fs');
require('dotenv').config();

class SolanaArbitrageBot {
    constructor() {
        this.connection = new Connection(process.env.SOLANA_RPC_URL || 'https://api.devnet.solana.com');
        this.wallet = this.loadWallet();
        this.isRunning = false;
    }

    loadWallet() {
        try {
            const keypairPath = process.env.KEYPAIR_PATH || `${process.env.HOME}/.config/solana/id.json`;
            const secretKey = JSON.parse(fs.readFileSync(keypairPath, 'utf8'));
            return Keypair.fromSecretKey(new Uint8Array(secretKey));
        } catch (error) {
            console.error('Error loading wallet:', error);
            process.exit(1);
        }
    }

    async initialize() {
        console.log('🚀 Initializing Solana Arbitrage Bot...');
        console.log('💳 Wallet Address:', this.wallet.publicKey.toString());
        
        try {
            const balance = await this.connection.getBalance(this.wallet.publicKey);
            console.log('💰 Wallet Balance:', balance / 1e9, 'SOL');
            
            if (balance === 0) {
                console.log('⚠️  Warning: Wallet has no SOL balance!');
                console.log('💡 Request airdrop with: solana airdrop 2');
            }
        } catch (error) {
            console.error('Error getting balance:', error);
        }
    }

    async findArbitrageOpportunities() {
        // TODO: Implement arbitrage logic
        console.log('🔍 Scanning for arbitrage opportunities...');
        
        // Example: Check price differences between DEXes
        // This is where you'll implement your arbitrage strategy
    }

    async start() {
        await this.initialize();
        this.isRunning = true;
        
        console.log('🎯 Bot started! Press Ctrl+C to stop.');
        
        // Start monitoring for opportunities
        const interval = setInterval(async () => {
            if (!this.isRunning) {
                clearInterval(interval);
                return;
            }
            
            try {
                await this.findArbitrageOpportunities();
            } catch (error) {
                console.error('Error in arbitrage scan:', error);
            }
        }, 5000); // Check every 5 seconds

        // Handle graceful shutdown
        process.on('SIGINT', () => {
            console.log('\n🛑 Shutting down bot...');
            this.isRunning = false;
            process.exit(0);
        });
    }
}

// Start the bot
const bot = new SolanaArbitrageBot();
bot.start().catch(console.error);
EOF
fi

# Install all dependencies
echo "📦 Installing all dependencies..."
npm install

# Check Solana installation
echo "✅ Verifying Solana installation..."
solana --version

# Check balance
echo "💰 Current balance:"
solana balance

# Display completion message
echo ""
echo "🎉 Solana Arbitrage Bot setup complete!"
echo ""
echo "📋 Quick start commands:"
echo "  npm start      - Start the bot"
echo "  npm run dev    - Start with auto-reload"
echo "  npm test       - Run tests"
echo ""
echo "📱 Useful Solana commands:"
echo "  solana balance           - Check wallet balance"
echo "  solana airdrop 2         - Request 2 SOL airdrop"
echo "  solana address           - Show wallet address"
echo "  solana config get        - Show current config"
echo ""
echo "🔧 Configuration files:"
echo "  .env                     - Environment variables"
echo "  src/index.js             - Main bot file"
echo "  ~/.config/solana/id.json - Solana keypair"
echo ""
echo "🚀 Ready to start building your arbitrage bot!"
EOF
