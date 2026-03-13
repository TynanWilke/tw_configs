# Tynan's Dotfiles

Personal configuration files for bash, tmux, and neovim with a one-command installation script.

## Features

- **Bash Configuration** (`bash/.bashrc.tynan`): Custom aliases, functions, and prompt customization
- **Tmux Configuration** (`tmux/.tmux.conf`): Sensible defaults with vim-style navigation and modern key bindings
- **Neovim Configuration** (`nvim/init.lua`): Minimal, performant setup with essential keybindings and settings
- **Automated Installation**: One-command setup that installs dependencies and configures everything
- **Secret Scanning**: GitHub Action to prevent accidental commits of API keys and sensitive data

## Repository Structure

```
.
├── bash/
│   └── .bashrc.tynan         # Custom bash configuration
├── tmux/
│   └── .tmux.conf            # Tmux configuration
├── nvim/
│   └── init.lua              # Neovim configuration
├── .github/workflows/
│   └── secret-scan.yml       # Security scanning workflow
├── install.sh                # Automated installation script
└── README.md                 # This file
```

## Quick Installation

### One-Line Install (via curl)

```bash
curl -fsSL https://raw.githubusercontent.com/TynanWilke/tw_configs/main/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/TynanWilke/tw_configs.git
cd tw_configs
chmod +x install.sh
./install.sh
```

## What Gets Installed

### Packages

The installation script will detect your OS and install:
- `tmux` - Terminal multiplexer
- `neovim` - Modern vim-based text editor
- `curl` - Data transfer tool

Supported systems:
- Ubuntu/Debian (apt)
- Fedora/RHEL/CentOS (dnf)
- Arch/Manjaro (pacman)
- macOS (homebrew)

### Configuration Files

- `~/.bashrc.tynan` - Custom bash configuration (sourced from `~/.bashrc`)
- `~/.bashrc.env` - Environment variables for API keys and secrets (sourced from `~/.bashrc`)
- `~/.tmux.conf` - Tmux configuration
- `~/.config/nvim/init.lua` - Neovim configuration

Existing configuration files are automatically backed up to `~/.config-backup-TIMESTAMP/` before installation.

**Important**: The `~/.bashrc.env` file is created with a template for storing API keys and environment variables. It has restricted permissions (600) and should never be committed to version control.

## Bash Configuration Highlights

- Enhanced history settings with deduplication
- Colorful prompt with user, host, and directory
- Useful aliases for common commands (`ll`, `la`, git shortcuts)
- Safety aliases for destructive commands (`rm -i`, `cp -i`, `mv -i`)
- Custom functions:
  - `mkcd` - Create and enter a directory
  - `extract` - Extract various archive formats

## Tmux Configuration Highlights

- Prefix changed from `Ctrl-b` to `Ctrl-a`
- Mouse support enabled
- Intuitive split commands: `|` for vertical, `-` for horizontal
- Vim-style pane navigation (`h`, `j`, `k`, `l`)
- Modern status bar with time/date
- 256 color support
- Copy mode with vi keybindings

### Key Bindings

- `Ctrl-a |` - Split vertically
- `Ctrl-a -` - Split horizontally
- `Ctrl-a h/j/k/l` - Navigate panes (vim-style)
- `Alt-Arrow` - Navigate panes without prefix
- `Ctrl-a r` - Reload configuration

## Neovim Configuration Highlights

- Line numbers (relative and absolute)
- Persistent undo with dedicated directory
- System clipboard integration
- Vim-style window navigation
- Smart indentation and search
- Auto-remove trailing whitespace on save
- Highlight on yank

### Key Bindings

Leader key: `Space`

- `Space + w` - Save file
- `Space + q` - Quit
- `Space + e` - File explorer
- `Space + h` - Clear search highlight
- `Ctrl-h/j/k/l` - Navigate windows
- `Shift-h/l` - Previous/next buffer

## Customization

After installation, you can customize the configurations:

```bash
# Edit bash config
nvim ~/.bashrc.tynan

# Edit tmux config
nvim ~/.tmux.conf

# Edit neovim config
nvim ~/.config/nvim/init.lua

# Add API keys and environment variables
nvim ~/.bashrc.env
```

After editing:
- Bash: `source ~/.bashrc`
- Tmux: `Ctrl-a r` (or `tmux source ~/.tmux.conf`)
- Neovim: Restart nvim

## Managing API Keys and Secrets

The installation creates `~/.bashrc.env` for storing API keys and sensitive environment variables:

```bash
# Edit the file to add your keys
nvim ~/.bashrc.env

# Example content:
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."
```

**Security notes:**
- File permissions are automatically set to `600` (owner read/write only)
- This file is sourced before `.bashrc.tynan` in your shell
- Never commit this file to version control
- Add `*.env` to your `.gitignore` if storing configs in a repo

## Security

This repository includes a GitHub Action that automatically scans for:
- API keys and tokens
- AWS credentials
- Private keys
- Passwords and secrets
- Hardcoded IPs and email addresses

The action runs on every push and pull request to the main branch.

## Uninstallation

To remove the configurations:

```bash
# Remove config files
rm ~/.bashrc.tynan ~/.tmux.conf
rm -rf ~/.config/nvim

# Remove sourcing from .bashrc
# Edit ~/.bashrc and remove the lines that source ~/.bashrc.tynan
```

Your backed-up configurations are stored in `~/.config-backup-*` directories.

## Contributing

Feel free to fork this repository and customize it for your own use. If you find issues or have improvements, pull requests are welcome.

## License

MIT License - Feel free to use and modify as needed.

## Troubleshooting

### Installation script fails to detect OS

If the auto-detection fails, you can manually install the dependencies:
- Install `tmux` and `neovim` using your package manager
- Run the script again

### Tmux colors look wrong

Ensure your terminal supports 256 colors. Add to your `~/.bashrc.tynan`:
```bash
export TERM=xterm-256color
```

### Neovim clipboard not working

Install a clipboard provider:
- Linux: `xclip` or `xsel`
- macOS: Built-in (should work out of the box)

## Future Enhancements

Potential improvements:
- Plugin manager support (lazy.nvim, vim-plug)
- Additional language-specific configurations
- Git configuration templates
- SSH configuration examples
