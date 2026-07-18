" Ott language file for vim
" Author: Peter-Michael Osera
" posera[at]cis[dot]upenn[dot]edu

if exists("b:current_syntax")
    finish
endif

syn case match

syn match   ottPuncuation           "::=\|::\|<::\|---\+\|\.\.\| | \|</\|/>\|//"
syn match   ottComment              "%.*$"
syn region  ottMorphism             start="{{" end="}}" contains=ottVarInMorphism, ottKeywordInMorphism
syn region  ottVarInMorphism        contained start="\[\[" end="\]\]"
syn match   ottKeywordInMorphism    contained "\<tex\>\|\<isa\>\|\<coq\>\|\<hol\>\|\<ocaml\>\|\<com\>\|\<coq-equality\>\|\<repr-locally-nameless\>\|\<phantom\>\|\<lex\>\|\<texvar\>\|\<isavar\>\|\<holvar\>\|\<ocamlvar\>\|\<coq-equality\>\|\<ich\>\|\<ic\>\|\<ch\>\|\<ih\>\|\<isasyn\>\|\<isaprec\>\|\<isaprec\>"

syn keyword ottKeyword              embed homs metavar indexvar grammar subrules
syn keyword ottKeyword              contextrules substitutions single multiple
syn keyword ottKeyword              freevars defns defn funs right left parsing
syn keyword ottKeyword              names distinctnames union by IN
" These keywords are more common; seems like it's more prudent to not highlight them
" syn keyword ottKeyword              fun bind in non

hi def link ottPuncuation            Structure
hi def link ottComment               Comment
hi def link ottMorphism              Macro
hi def link ottVarInMorphism         Identifier
hi def link ottKeywordInMorphism     Keyword

hi def link ottRule                  Normal

hi def link ottKeyword               Keyword

let b:current_syntax = "ott"
