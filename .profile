ENV=$HOME/.shrc; export ENV
PATH=$HOME/.local/bin:$PATH; export PATH
LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH; export LD_LIBRARY_PATH

if [ -e /home/user/.nix-profile/etc/profile.d/nix.sh ]; then
    . /home/user/.nix-profile/etc/profile.d/nix.sh;
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
