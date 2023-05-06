; Setup boilerplate to allow us to use the vim and neovim apis with a lispy
; naming scheme ("-" as separator instead of "_")

(local v {})

(setmetatable v
  {:__index
    (fn [tbl key] (. vim.fn (vim.fn.substitute key "-" "_" :g)))})

(fn compute-lookup-table-for-api []
  (let [api-functions (. (v.api-info) :functions)
        generated-lookup-table {}]
    (each [_ value (ipairs api-functions)]
      (let [actual-api-function
                (. vim.api (. value :name))
            generated-function-name
                (vim.fn.substitute (. value :name) "_" "-" :g)]
        (tset generated-lookup-table generated-function-name
              actual-api-function)))
    generated-lookup-table))

(local a (compute-lookup-table-for-api))

(fn set-options [options]
  (each [key value (pairs options)]
    (tset vim.opt key value)))

(fn set-global-vars [vars]
  (each [key value (pairs vars)]
    (a.nvim-set-var key value)))

(fn set-key-maps [mode maps]
  (each [key value (pairs maps)]
    (vim.keymap.set mode key
        (if (and (not= (type value) :function) (= mode :n))
            (.. value :<CR>) ; then 
            value) ; else 
        {:silent true})))

(fn set-normal-maps [maps keybind]
  (set-key-maps :n (collect [key value (pairs maps)]
                     (.. keybind key)
                     value)))

(fn set-leader-maps [maps]
  (set-normal-maps maps :<Leader>))

(fn set-localleader-maps [maps]
  (set-normal-maps maps :<LocalLeader>))

{: v
 : a
 : set-options
 : set-global-vars
 : set-leader-maps
 : set-localleader-maps
 : set-key-maps}
