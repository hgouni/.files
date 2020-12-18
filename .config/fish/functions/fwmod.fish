function fwmod
    command firewall-cmd --zone=public --permanent $argv
end

