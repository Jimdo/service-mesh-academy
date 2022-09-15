# Extra functions to make my life a little easier with demo-magic.

# "p" is exactly like demo-magic except that it uses new variable PROMPT_WAIT
# to control whether you have to hit ENTER to start the command, and NO_WAIT
# for whether you hit ENTER after showing the command.
#
# (I don't like to have to hit ENTER to run one command, then hit ENTER
# again right after to start the next one.)
function p() {
  if [[ ${1:0:1} == "#" ]]; then
    cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  else
    cmd=$DEMO_CMD_COLOR$1$COLOR_RESET
  fi

  # render the prompt
  x=$(PS1="$DEMO_PROMPT" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')

  # show command number is selected
  if $SHOW_CMD_NUMS; then
   printf "[$((++C_NUM))] $x"
  else
   printf "$x"
  fi

  # wait for the user to press a key before typing the command
  if [ $PROMPT_WAIT = true ]; then
    wait
  fi

  if [[ -z $TYPE_SPEED ]]; then
    echo -en "$cmd"
  else
    echo -en "$cmd" | pv -qL $[$TYPE_SPEED+(-2 + RANDOM%5)];
  fi

  # wait for the user to press a key before moving on
  if [ $NO_WAIT = false ]; then
    wait
  fi
  echo ""
}

# Print immediately.
pi () {
  NO_WAIT=true DEMO_PROMPT= p "$@"
}

# Like echo, but let demo-magic colorize it maybe.
show () {
  NO_WAIT=true DEMO_PROMPT= TYPE_SPEED= p "$@"
}

# Like echo, but assume it's a command.
cmd () {
  NO_WAIT=true DEMO_PROMPT='$ ' TYPE_SPEED= p "$@"
}
