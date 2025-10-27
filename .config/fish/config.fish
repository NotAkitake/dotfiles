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
set -x PATH ~/.cargo/bin $PATH

# Custom aliases
alias vim=nvim
alias q=exit

# Custom abbreviations
if status --is-interactive
    abbr --add grubup 'sudo grub-mkconfig -o /boot/grub/grub.cfg'
    abbr --add sshxyz 'ssh -i $XYZ_SSH_KEY $XYZ_SSH_USER@$XYZ_SSH_HOST'
    abbr --add fishcfg 'vim ~/.config/fish/config.fish'
    abbr --add termcfg 'vim ~/.config/kitty/kitty.conf'
    abbr --add vimcfg 'vim ~/.config/nvim/'
    abbr --add niricfg 'vim ~/.config/niri/config.kdl'
end

# Override 'edit' to always use nvim
function edit
    nvim $argv
end

# Override greeting to disabling fastfetch
function fish_greeting
end
