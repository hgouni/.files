set -e          # immediately exit on failure
set -u          # treat uninitialized variables as an error
set -o pipefail # pipes return error if any commands do

for file in $(find "$HOME/.config/nvim" -type f -name '*.fnl'); do

    fennel --compile "$file" | tee "$(printf '%s\n' $file | sed -e 's/fnl/lua/g')" > /dev/null

    if [ "$?" -eq 0 ]; then
        printf "%s compiled\n" $file
    else
        printf "error compiling %s\n" $file
    fi
done
