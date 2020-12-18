function sewebdir
    command chcon -Rt httpd_sys_content_t $argv
end

