### CachyOS config
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

### Private environment variables
if test -f ~/.config/fish/private_env.fish
    source ~/.config/fish/private_env.fish
end

### Environment variables
set -gx EDITOR helix
set -gx VISUAL helix
set -gx SUDO_EDITOR helix
set -gx TERM kitty
set -gx TERMINAL kitty
set -gx KDE_TERMINAL kitty

### Paths
fish_add_path ~/.cargo/bin

### Aliases
alias hx="helix"
alias vim="nvim"
alias q="exit"
alias fastfetch="fastfetch -c arch"

### Abbreviations
if status --is-interactive
    abbr --add grubup 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
    abbr --add sshxyz 'ssh -i $XYZ_SSH_KEY $XYZ_SSH_USER@$XYZ_SSH_HOST'
    abbr --add fishcfg 'edit ~/.config/fish/config.fish'
    abbr --add termcfg 'edit ~/.config/kitty/kitty.conf'
    abbr --add hxcfg 'edit ~/.config/helix/config.toml'
    abbr --add vimcfg 'edit ~/.config/nvim/'
    abbr --add niricfg 'edit ~/.config/niri/config.kdl'
    abbr --add syncnas '~/.scripts/syncnas.sh'
end

### Override `edit` to always use helix
function edit
    helix $argv
end

### rclone: Nextcloud sync helper
function syncnc
    # Upload
    for d in Documents Music Pictures
        echo "- Uploading: $d..."
        rclone sync /mnt/HDD/Cloud/$d nc:/$d $argv --progress
    end

    # Download
    for d in Recipes
        echo "- Downloading: $d..."
        rclone sync nc:/$d /mnt/HDD/Cloud/$d $argv --progress
    end
end

# Optional: disable fish greeting
# function fish_greeting; end
