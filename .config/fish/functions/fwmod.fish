function fwmod
    firewall-cmd --zone=public --permanent $argv
end

