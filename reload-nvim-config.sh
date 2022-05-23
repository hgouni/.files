for file in $(find "$HOME/.config/nvim" -type f -name '*.fnl'); do
    fennel --compile "$file" | tee "$(printf '%s\n' $file | sed -e 's/fnl/lua/g')"
done
