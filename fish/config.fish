set -Ux HYPRSHOT_DIR "$HOME/Pictures"
if status is-interactive
    
end

function curdir
    echo (set_color red)$PWD
end

function larp
    echo boii larpsec is the best
    echo sudo apt install opsec
    echo sudo opsec
    echo error: user is larper
    echo error: broski just install ubuntu
end

function home
    cd /home/$USER
end

function shutdown
    sudo shutdown -h now
end

function update
    sudo pacman -Syu
end
