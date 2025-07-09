#!/bin/bash

set -e

echo "🚀 Setting up Solana Arbitrage Development Environment"

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
echo "🔧 Installing essential packages..."
sudo apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    pkg-config \
    libudev-dev \
    libssl-dev \
    libclang-dev \
    ca-certificates \
    gnupg \
    lsb-release

# Install Node.js v23.11.0
echo "📱 Installing Node.js v23.11.0..."
curl -fsSL https://nodejs.org/dist/v23.11.0/node-v23.11.0-linux-x64.tar.xz -o node-v23.11.0-linux-x64.tar.xz
sudo tar -C /usr/local --strip-components=1 -xJf node-v23.11.0-linux-x64.tar.xz
rm node-v23.11.0-linux-x64.tar.xz

# Install Yarn v1.22.22
echo "🧶 Installing Yarn v1.22.22..."
curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version 1.22.22
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Install Rust v1.86
echo "🦀 Installing Rust v1.86..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.86.0
source $HOME/.cargo/env

# Install Solana CLI v2.2.20
echo "☀️ Installing Solana CLI v2.2.20..."
sh -c "$(curl -sSfL https://release.anza.xyz/v2.2.20/install)"
export PATH="/home/vscode/.local/share/solana/install/active_release/bin:$PATH"

# Install Anchor v0.31.1
echo "⚓ Installing Anchor v0.31.1..."
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force
avm install 0.31.1
avm use 0.31.1

# Create workspace directory
echo "📁 Creating workspace directory..."
mkdir -p /workspace/solana-arbitrage
cd /workspace/solana-arbitrage

# Initialize Anchor project
echo "🏗️ Initializing Anchor project..."
anchor init solana-arbitrage --no-git

# Install common dependencies
echo "📦 Installing common dependencies..."
cd solana-arbitrage
npm install @solana/web3.js @solana/spl-token @project-serum/anchor

# Setup Solana config
echo "⚙️ Setting up Solana configuration..."
solana config set --url localhost
solana-keygen new --no-bip39-passphrase --silent --outfile ~/.config/solana/id.json

# Create .env file
echo "📄 Creating .env file..."
cat > .env << EOF
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
EOF

# Create basic arbitrage structure
echo "🏗️ Creating project structure..."
mkdir -p {src,tests,scripts,config}

# Create basic package.json scripts
echo "📜 Adding npm scripts..."
cat > package.json << 'EOF'
{
  "name": "solana-arbitrage",
  "version": "1.0.0",
  "description": "Solana arbitrage trading bot",
  "main": "index.js",
  "scripts": {
    "build": "anchor build",
    "test": "anchor test",
    "deploy": "anchor deploy",
    "start": "node src/index.js",
    "dev": "nodemon src/index.js"
  },
  "dependencies": {
    "@solana/web3.js": "^1.95.0",
    "@solana/spl-token": "^0.4.0",
    "@project-serum/anchor": "^0.30.0",
    "dotenv": "^16.0.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0"
  }
}
EOF

# Install project dependencies
echo "📦 Installing project dependencies..."
npm install

# Set up Git (optional)
echo "🔄 Setting up Git..."
git init
git add .
git commit -m "Initial Solana arbitrage setup"

# Final setup messages
echo "✅ Setup complete!"
echo ""
echo "🎉 Solana Arbitrage Development Environment Ready!"
echo ""
echo "Versions installed:"
echo "- Solana CLI: v2.2.20"
echo "- Anchor: v0.31.1"
echo "- Rust: v1.86"
echo "- Node.js: v23.11.0"
echo "- Yarn: v1.22.22"
echo ""
echo "Next steps:"
echo "1. cd /workspace/solana-arbitrage/solana-arbitrage"
echo "2. Start local validator: solana-test-validator"
echo "3. Run tests: anchor test"
echo "4. Start development: npm run dev"
echo ""
echo "Happy arbitraging! 🚀"
