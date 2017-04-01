autoload -U colors && colors
psvar[1]=""
PROMPT="%(#.%F{red}.%F{cyan})%n@%m:%F{white}%~\$psvar[1]%F{cyan}%#%f "
RPROMPT="%F{cyan}[%B%F{white}%D{%H}%b:%D{%M}:%D{%S}%F{cyan}]%f"
