function sewebdir
    chcon -Rt httpd_sys_content_t $argv
end

