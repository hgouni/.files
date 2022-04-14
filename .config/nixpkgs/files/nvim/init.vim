set shell=sh

call system("fennel --compile " . $HOME . "/.config/nvim/config.fnl | tee " . $HOME . "/.config/nvim/config.lua")

source $HOME/.config/nvim/config.lua

