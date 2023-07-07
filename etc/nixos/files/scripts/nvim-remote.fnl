; want this to be as fast as possible so not registering functions yet
(when (not (os.getenv "NVIM"))
  (os.execute (.. "nvim " (table.concat _G.arg " "))) 
  (os.exit))

(fn system [command opts]
  (let [fd (io.popen command)
        output (fd:read opts)]
    ; close the fd
    (fd:close)
    output))

(fn prepend-abs-path [arg-array]
  (each [idx str (ipairs arg-array)]
    ; we don't want to change absolute paths
    (when (~= "/" (string.sub str 1 1))
      ; read only a line since a command can't contain newlines
      ; (reading *all will cause a newline to be read, adds nothing for `pwd`)
      (tset arg-array idx (.. (system "pwd" "*line") "/" str))))
  arg-array)

; build the final command
(os.execute (.. "nvim --server \"$NVIM\" --remote-tab "
                ; add processed args
                (table.concat (prepend-abs-path _G.arg) " ")))
