# CachyOS fish config
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Private environment variables
if test -f ~/.config/fish/private_env.fish
    source ~/.config/fish/private_env.fish
end

# Custom variables
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux TERM kitty
set -Ux TERMINAL kitty
set -Ux KDE_TERMINAL kitty
set -x PATH ~/.cargo/bin $PATH

# Custom aliases
alias vim=nvim
alias q=exit
alias fastfetch="fastfetch -c arch"

# Custom abbreviations
if status --is-interactive
    abbr --add grubup 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
    abbr --add sshxyz 'ssh -i $XYZ_SSH_KEY $XYZ_SSH_USER@$XYZ_SSH_HOST'
    abbr --add fishcfg 'vim ~/.config/fish/config.fish'
    abbr --add termcfg 'vim ~/.config/kitty/kitty.conf'
    abbr --add vimcfg 'vim ~/.config/nvim/'
    abbr --add niricfg 'vim ~/.config/niri/config.kdl'
    abbr --add syncnas '~/.scripts/syncnas.sh'
end

# Override 'edit' to always use nvim
function edit
    nvim $argv
end

# rclone: Nextcloud
function rcnc
    for d in Documents Music Pictures
        rclone sync /mnt/HDD/Cloud/$d nc:/$d $argv --progress
    end
end

# Disable greeter
#function fish_greeting
#end
