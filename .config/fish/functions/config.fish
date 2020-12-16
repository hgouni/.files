function config --wraps git
    switch "$argv[1]"
    case --reset
        cd "$HOME"
        and for file in (config ls-tree -r master --name-only)
                rm $file
            end
        and rm "$HOME/.files"
        and command git clone --bare https://github.com/lawabidingcactus/.files.git "$HOME/.files"
        and config checkout
        and config config --local status.showUntrackedFiles no
    case "*"
        command git --git-dir="$HOME/.files/" --work-tree="$HOME" $argv
    end
end
