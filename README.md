# Nikita's personal dotfiles

zsh, Neovim (LazyVim) and tmux for macOS.

## Install

```sh
git clone https://github.com/slepogin/dotfiles.git ~/dev/dotfiles
~/dev/dotfiles/install.sh
```

`install.sh` symlinks the configs and runs `brew bundle`. It is safe to re-run;
anything already in the way is moved to `<name>.bak.<timestamp>`.

## Layout

| Repo         | Linked to           | Notes                                          |
| ------------ | ------------------- | ---------------------------------------------- |
| `zsh/zshrc`  | `~/.zshrc`          | machine-specific bits go in `~/.zshrc.local`   |
| `nvim/`      | `~/.config/nvim`    | LazyVim; plugin versions pinned in `lazy-lock.json` |
| `tmux/`      | `~/.config/tmux`    | tmux 3.8+, no plugins                          |
| `Brewfile`   | —                   | packages the configs depend on                 |

The repo is symlinked, so editing a config in place edits the repo.

## macOS: remap the tilde key

```sh
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}]}'
```
