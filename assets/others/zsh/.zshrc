export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
#complete -o nospace -C /opt/homebrew/bin/terraform terraform

autoload -Uz compinit
compinit

# az autocomplete
source ~/.zsh_functions/az.completion

alias tf="terraform"

flushdns () {
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder;
}

etchost () {
    sudo nano /etc/hosts;
}

cloudmemory () {
    code ~/Projects/cloudmemory/
}

