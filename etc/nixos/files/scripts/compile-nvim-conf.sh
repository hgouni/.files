set -e          # immediately exit on failure
set -u          # treat uninitialized variables as an error
set -o pipefail # pipes return error if any commands in them do

shopt -s globstar nullglob # - globstar allows for **, recurses into subdirectories
                           # - nullglob causes globs matching nothing to be
                           #   expanded to nothing, instead of to themselves

for file in "$HOME"/.config/nvim/**/*.fnl; do
    fennel --compile "$file" | tee "$(printf '%s\n' "$file" | sed -e 's/fnl/lua/g')" > /dev/null
    printf '%s compiled\n' "$file"
done
