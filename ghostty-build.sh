#!/usr/bin/bash
set -euo pipefail

# Ghostty build instructions:
# https://ghostty.org/docs/install/build

# Public key for Ghostty:
PUBLIC_KEY="RWQlAjJC23149WL2sEpT/l0QKy7hMIFhYdQOFy0Z7z7PbneUgvlsnYcV"

# 1. Install Dependencies
echo "Installing dependencies..."
sudo zypper install -y \
  gtk4-devel \
  libadwaita-devel \
  pkgconf \
  ncurses-devel \
  zig \
  gettext \
  curl \
  tar \
  minisign \
  gtk4-layer-shell-devel

# 2. Get the Source Code and Signature
echo "Cleaning up old build files..."
rm -f ghostty-source.tar.gz ghostty-source.tar.gz.minisig
rm -rf ghostty-src

echo "Downloading source tarball..."
SOURCE_URL="https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz"
curl -L -o ghostty-source.tar.gz "$SOURCE_URL"

echo "Downloading signature..."
curl -L -o ghostty-source.tar.gz.minisig "$SOURCE_URL.minisig"

# 3. Verify Signature
echo "Verifying signature..."
minisign -Vm ghostty-source.tar.gz -P "$PUBLIC_KEY"

# 4. Extract
echo "Extracting source..."
mkdir -p ghostty-src
tar -xf ghostty-source.tar.gz -C ghostty-src --strip-components=1

cd ghostty-src

# 5. Build and Install
echo "Building Ghostty..."
# We use system libraries for everything now.
# We install to ~/.local
zig build -p "$HOME/.local" -Doptimize=ReleaseFast

echo "Ghostty has been built and installed to $HOME/.local/bin/ghostty"
echo "Make sure $HOME/.local/bin is in your PATH."
