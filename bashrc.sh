# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# Add a custom colour prompt
CUSTOM_PROMPT="~"
bldylw='\e[1;33m'
bldgrn='\e[1;32m'
bldblu='\e[1;34m'
txtrst='\e[0m'
print_before_the_prompt () {
	printf "$bldylw[$bldgrn pyuser@docker: $bldblu%s $bldylw]\n$txtrst" "${PWD/$HOME/$CUSTOM_PROMPT}"
}
PROMPT_COMMAND=print_before_the_prompt
PS1='~> '

