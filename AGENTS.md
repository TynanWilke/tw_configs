# AGENTS.md

## Repo overview

Personal dotfiles repo: bash, tmux, neovim, opencode, and claude configs with an automated install script. No build system or tests; CI runs secret scanning and linting.

## Structure

- `bash/.bashrc.tynan` — sourced from `~/.bashrc` (not `~/.bash_profile`)
- `tmux/.tmux.conf` — copied to `~/.tmux.conf`
- `nvim/init.lua` — copied to `~/.config/nvim/init.lua`
- `opencode/opencode.json` — copied to `~/.config/opencode/opencode.json`
- `install.sh` — single entry point; installs packages (OS-aware), copies configs, creates `~/.bashrc.env`
- `.github/workflows/secret-scan.yml` — CI only; TruffleHog + Gitleaks + custom pattern scan

## Key conventions

- **Install script works both locally and via curl** — it detects whether local files exist and falls back to downloading from GitHub raw URLs. The curl URL references `TynanWilke/bash_configs` (historical repo name), not `tw_configs`.
- **Neovim requires >= 0.10** — `install.sh` auto-installs v0.11.5 to `~/bin/nvim` if the system version is too old.
- **`~/.bashrc.env`** — secrets file created on install with `chmod 600`; sourced *before* `.bashrc.tynan` in `~/.bashrc`. Never committed.
- **Neovim uses lazy.nvim** — plugins bootstrap on first launch. Avante and Copilot both require API keys in `~/.bashrc.env` (`ANTHROPIC_API_KEY`, `GITHUB_TOKEN`).
- **Tmux uses TPM** — plugins install on first launch via `~/.tmux/plugins/tpm/tpm`.
- **Tmux prefix is `Ctrl-a`**, not the default `Ctrl-b`.
- **Neovim leader is `Space`**.
- **Existing configs are backed up** to `~/.config-backup-TIMESTAMP/` before overwrite.

## Verification

No tests exist. To verify changes:
- Bash: `source ~/.bashrc` and check prompt/aliases
- Tmux: `tmux source ~/.tmux.conf` or `Ctrl-a r`
- Neovim: restart nvim; `:checkhealth` and `:Lazy` for plugin status

## CI

On push/PR to `main`, `master`, and `develop`:

- **Secret scanning** (`.github/workflows/secret-scan.yml`): TruffleHog, Gitleaks, and custom grep patterns. Gitleaks requires a `GITLEAKS_LICENSE` secret.
- **Linting** (`.github/workflows/lint.yml`): `bash -n` + ShellCheck (`--severity=warning`), Lua syntax (`luac5.1 -p`), JSON validation (`jq empty`), `actionlint` for workflows, and a tmux config parse test.
