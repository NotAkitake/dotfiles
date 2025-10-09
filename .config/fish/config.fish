# CachyOS fish config
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Private environment variables
if test -f ~/.config/fish/private_env.fish
    source ~/.config/fish/private_env.fish
end

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
end

# Overwrite greeting, disabling fastfetch
function fish_greeting
end
