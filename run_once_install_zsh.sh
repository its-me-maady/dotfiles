#!/usr/bin/env sh

# 1. Install Zsh (if not already installed)
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    sudo pacman -S --noconfirm zsh
fi

# 2. Install Oh My Zsh (Unattended)
# We check if the folder exists to avoid errors on repeated runs
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # The installer replaces your .zshrc. We need to remove the default one 
    # so your dotfiles manager (Chezmoi) can put YOURS back.
    rm "$HOME/.zshrc"
fi

# 3. Install Powerlevel10k
# We clone it into the standard OMZ custom themes folder
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# 4. (Optional) Install useful plugins like Syntax Highlighting & Autosuggestions
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 5. Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(which zsh)"
fi
