function sewebfile
    command chcon -t httpd_sys_content_t $argv
end

