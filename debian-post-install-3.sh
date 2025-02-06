#! /usr/bin/env bash

#=================================================================
# Installation script for Linux Operating system
# Purpose: Automate system package installation and R build
# Created: December 2024
# Updated: Feb. 5, 2025
#=================================================================

# Exit on any error and enable error tracing
set -e
set -x

# Start timestamp for logging
echo "==> Starting installation: $(date)"

#=================================================================
# Backup existing configurations
#=================================================================
echo "==> Backing up existing configurations..."
if cp ~/.bashrc ~/.bashrc.backup; then
    echo "==> Backed up .bashrc successfully"
else
    echo "WARNING: .bashrc backup failed, continuing..."
fi

echo "==> Copying other dot files to home directory..."
cp LinuxSetup/{.bash_aliases,.bashrc,.gitconfig,.gitignore,.Rprofile} ~
echo "==> Activating bash aliases!"

#=================================================================
# System Updates
#=================================================================
echo "==> Updating system packages..."
sudo apt update && sudo apt upgrade -y

#=================================================================
# Install Essential Tools & R Build Dependencies
#=================================================================
echo "==> Installing system utilities and build dependencies..."

# System utilities
echo "==> Installing system tools..."
sudo apt install -y build-essential git curl wget xclip openssh-server \
    nmap libnss-mdns arp-scan trash-cli fonts-firacode \
    net-tools htop dnsutils ufw samba openvpn smartmontools gparted \
    tldr

# R build requirements
echo "==> Installing R build dependencies..."
sudo apt install -y gfortran libreadline-dev libx11-dev libxt-dev \
    libpng-dev libjpeg-dev libcairo2-dev xvfb libbz2-dev libzstd-dev \
    liblzma-dev libcurl4-openssl-dev libpcre2-dev cmake openjdk-17-jdk \
    #openjdk-11-jdk 

# Additional R package dependencies
echo "==> Installing R package dependencies..."
sudo apt install -y libsodium-dev libxml2-dev libgmp3-dev libpq-dev \
    libgdal-dev libudunits2-dev libharfbuzz-dev libfribidi-dev \
    libnode-dev libmagick++-dev libmpfr-dev libssl-dev \
    default-libmysqlclient-dev libxslt-dev gdal-bin libsqlite3-dev \
    libtiff-dev libfreetype-dev

#=================================================================
# R Installation
#=================================================================
echo "==> Beginning R installation..."

# Change to home directory
cd ~ || {
    echo "ERROR: Could not change to home directory"
    exit 1
}

# Download and extract R source
echo "==> Downloading R 4.4.2 source..."
wget https://cran.r-project.org/src/base/R-4/R-4.4.2.tar.gz || {
    echo "ERROR: R source download failed"
    exit 1
}

echo "==> Extracting R source..."
tar -xf R-4.4.2.tar.gz || {
    echo "ERROR: R extraction failed"
    exit 1
}

cd R-4.4.2 || {
    echo "ERROR: Could not change to R source directory"
    exit 1
}

# Configure R
echo "==> Configuring R build..."
./configure --with-x --enable-R-shlib || {
    echo "ERROR: R configuration failed"
    exit 1
}

# Build R
echo "==> Building R..."
make || {
    echo "ERROR: R build failed"
    exit 1
}

# Install R
echo "==> Installing R..."
sudo make install || {
    echo "ERROR: R installation failed"
    exit 1
}

# Verify installation
echo "==> Verifying R installation..."
sudo chown -R $USER:$USER /usr/local/lib/R
sudo chmod -R 755 /usr/local/lib/R

R --version || {
    echo "ERROR: R verification failed"
    exit 1
}

#=================================================================
# R Package Installation
#=================================================================
echo "==> Downloading R package list..."

echo "==> Installing R packages..."
Rscript ~/packages-i-use.R || {
    echo "ERROR: R package installation failed"
    echo "Note: Some package failures are normal and can be addressed later"
}

if wget -q --show-progress --retry-connrefused --waitretry=5 \
	 https://raw.githubusercontent.com/kyleGrealis/r-accessories/refs/heads/main/packages-i-use.R -O ~/packages-i-use.R; then
    echo "==> Installing R packages..."
    Rscript ~/packages-i-use.R || {
        echo "ERROR: R package installation failed"
        echo "Note: Some package failures are normal and can be addressed later"
    }
else
    echo "ERROR: Failed to download R package list"
    echo "Installing minimal R packages..."
    sudo R -e "install.packages(c('remotes','devtools','tidyverse'), repos='https://cloud.r-project.org')" || {
	echo "Ooops... you have to run that yourself"
    }
fi

if wget --show-progress --retry-connrefused --waitretry=5 \
       	-O ~/Downloads/quarto-latest.deb \
       	https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.13/quarto-1.7.13-linux-amd64.tar.gz; then
    echo "==> Installing the latest Quarto..."
else
    echo "ERROR: Manually download Quarto"
fi


https://github.com/posit-dev/positron/releases/download/2025.02.0-137/Positron-2025.02.0-137-arm64.deb
if wget --show-progress --retry-connrefused --waitretry=5 \
       	-O ~/Downloads/quarto-latest.deb \
       	https://github.com/posit-dev/positron/releases/download/2025.02.0-137/Positron-2025.02.0-137-arm64.deb; then
    echo "==> Installing the latest Positron..."
else
    echo "ERROR: Manually download Positron"
fi

#=================================================================
# Installing Tailscale
#=================================================================
echo "==> Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

#=================================================================
# Installation Complete
#=================================================================
echo "==> Installation completed successfully at $(date)"
echo "==> Please check the verification steps in the setup guide"
