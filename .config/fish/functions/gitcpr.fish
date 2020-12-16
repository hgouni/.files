function gitcpr -a repo branch
    command git clone "$repo"
    and cd (command ls -t | command sed -n 1p)
    and command git checkout -b "$branch"
end
