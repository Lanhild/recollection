#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
# file transferring function over transfer.sh

transfer(){
if [ $# -eq 0 ];then
    echo "No arguments specified."
    echo "Usage:"
    echo "transfer <file|directory>"
    echo " ... | transfer <file_name>">&2;
      return 1;
fi;
if tty -s;then
    file="$1";file_name=$(basename "$file");
  if [ ! -e "$file" ];then
      echo "$file: No such file or directory">&2;
        return 1;
fi;
if [ -d "$file" ];then
      file_name="$file_name.zip" ;
        (cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file  "-" "https://transfer.sh/$file_name";
          else cat "$file"|curl -X PUT --upload-file "-" "https://transfer.sh/$file_name";
fi;
          else file_name=$1;curl --upload-file "-" "https://transfer.sh/$file_name";
fi;
}


function cd {
	if [ -z "$1" ]; then
		builtin cd
	else
		builtin cd "$1"
	fi
	if [ $? -eq 0 ]; then
		ptls
	fi
}

# directly change in the created 'mkdir' directory by using the custom 'mkcd' command

ptmkdir () {
  case "$1" in
    */..|*/../) cd -- "$1";; # that doesn't make any sense unless the directory already exists
    /*/../*) (cd "${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd -- "$1";;
    /*) mkdir -p "$1" && cd "$1";;
    */../*) (cd "./${1%/../*}/.." && mkdir -p "./${1##*/../}") && cd "./$1";;
    ../*) (cd .. && mkdir -p "${1#.}") && cd "$1";;
    *) mkdir -p "./$1" && cd "./$1";;
  esac
}

alias x='exit'
alias ls="ptls"
alias pwd="ptpwd"
alias mkdir="ptmkdir"
alias touch="pttouch"
alias cp="ptcp"

# The magical prompt
RESET="\[\033[01;00m\]"
FG_MAGNETA="\[\033[01;35m\]"
FG_BLACK="\[\033[01;30m\]"
FG_GREEN="\[\033[01;32m\]"
FG_BLUE="\[\033[01;34m\]"
FG_YELLOW="\[\033[01;33m\]"
FG_BRIGHT_GREEN="\[\033[01;92m\]"
FG_CYAN="\[\033[01;36m\]"

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

write_prefix() {
  echo -n "${debian_chroot:+($debian_chroot)}${FG_MAGNETA}\u${FG_BLUE}┬${FG_GREEN}\h"
  echo -n "${FG_YELLOW}"
  echo -n "[ \[\e[39;1m\]\w\[\e[31;1m\] ]"
  echo -n "\$(parse_git_branch)"
  echo -n "${RESET}\n"
  
  me="$USER"
  for (( i=0; i<${#me}; i++ )) do
    echo -n " "
  done
  echo "${FG_BLUE}└${FG_BLUE} \$${RESET} "
}

PS1="$(write_prefix)"

# autostart xserver after tty login
if [ $(tty) = /dev/tty1 ]; then
	startx
	exit 0;
fi
