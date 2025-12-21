# Arch Linux Configuration

This directory contains your converted NixOS configuration for use with Arch Linux. The configuration has been reorganized to work without home-manager.

## Directory Structure

```
arch-config/
├── fish/               # Fish shell configuration
│   └── config.fish
├── zsh/                # Zsh configuration
│   └── .zshrc
├── tmux/               # Tmux configuration
│   └── tmux.conf
├── git/                # Git configuration
│   └── .gitconfig
├── scripts/            # Utility scripts
│   └── setup-symlinks.sh
├── packages.txt        # Official Arch packages
├── aur-packages.txt    # AUR packages
└── README.md           # This file
```

## Quick Start

### 1. Install Packages

**Official Packages:**
```bash
sudo pacman -S --needed - < packages.txt
```

**AUR Packages** (requires yay or paru):
```bash
# First install an AUR helper if you don't have one
# For yay:
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# Then install AUR packages:
yay -S --needed - < aur-packages.txt
```

### 2. Set Up Symlinks

Run the setup script to create symlinks for all configurations:

```bash
./scripts/setup-symlinks.sh
```

This will:
- Link fish config to `~/.config/fish/`
- Link zsh config to `~/.zshrc`
- Link tmux config to `~/.config/tmux/`
- Link git config to `~/.gitconfig`
- Link all NixOS Configs (kitty, nvim, hypr, etc.) to their respective locations

### 3. Install Plugin Managers

**Tmux Plugin Manager (TPM):**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# Then press prefix + I inside tmux to install plugins
```

**Fish Plugin Manager (fisher):**
```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
# Install recommended plugins:
fisher install jethrokuan/fzf
fisher install jorgebucaran/autopair.fish
```

**Zsh Plugin Manager (zinit):**
```bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
# Then uncomment the zinit plugin lines in .zshrc
```

### 4. Set Default Shell

Choose your preferred shell:

```bash
# For Fish:
chsh -s /usr/bin/fish

# For Zsh:
chsh -s /usr/bin/zsh
```

## Configuration Details

### Shell Features

Both Fish and Zsh configurations include:
- **Aliases:** Modern replacements using `eza`, `trash-cli`, etc.
- **Functions:**
  - `nvim` wrapper for better directory handling
  - `display_pokemon_fastfetch` for startup display
- **Environment:** XDG_CONFIG_HOME, EDITOR, PATH additions
- **Prompt:** Starship prompt integration

### Git Configuration

The git config includes:
- User: KMohZaid
- SSH commit signing
- Useful aliases (st, co, br, lg, etc.)

**Note:** Make sure to add your SSH key to ssh-agent for commit signing to work:
```bash
ssh-add ~/.ssh/github_rsa.key
```

### Tmux Configuration

Features:
- Catppuccin Mocha theme
- Mouse support
- Custom keybindings for splits (`|` and `-`)
- Plugins: cpu, battery, which-key
- Image passthrough for Neovim

### Desktop Environment

Hyprland and related configs are symlinked from the NixOS Configs directory:
- **hypr:** Hyprland window manager configuration
- **kitty:** Terminal emulator
- **swaylock/swayidle:** Lock screen and idle management
- **wlogout:** Logout menu
- **fastfetch:** System info display

## Package Notes

### Replaced Packages

Some NixOS packages have been replaced with Arch equivalents:
- `pokemon-colorscripts-mac` → `pokemon-colorscripts` (AUR)
- `trashy` → `trash-cli` or `trashy` (AUR)

### Optional Packages

Some packages from your NixOS config that might need manual installation:
- **Flatpak apps:** Some apps might be better installed via Flatpak (Zoom, etc.)
- **Python packages:** You may want to use `pipx` for isolated Python tools
- **Node.js packages:** Consider using `pnpm` or `npm` globally for some tools

### Development Environments

For version managers, consider:
- **Node.js:** `nvm` or `fnm`
- **Python:** `pyenv`
- **Ruby:** `rbenv`
- **Rust:** Already uses `rustup`

## Maintenance

### Updating Packages

```bash
# Update official packages
sudo pacman -Syu

# Update AUR packages
yay -Syu
```

### Backup

Your original configurations are backed up with `.backup` extension by the setup script.

## Troubleshooting

### Fish/Zsh plugins not loading

Make sure you've installed the plugin managers (fisher/zinit) and run the installation commands.

### Tmux plugins not showing

1. Install TPM
2. Open tmux
3. Press `prefix + I` (prefix is usually Ctrl-b)

### Pokemon display not working

Install `pokemon-colorscripts` from AUR:
```bash
yay -S pokemon-colorscripts
```

### Hyprland not starting

Make sure you have all Wayland dependencies:
```bash
sudo pacman -S xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland
```

## Additional Resources

- [Arch Wiki](https://wiki.archlinux.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Fish Documentation](https://fishshell.com/docs/current/)
- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
