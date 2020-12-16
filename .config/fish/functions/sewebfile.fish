function sewebfile
    chcon -t httpd_sys_content_t $argv
end

