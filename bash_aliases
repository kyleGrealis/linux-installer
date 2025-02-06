# restart terminal session ----------------------
alias restart='source ~/.bashrc'

# git -------------------------------------------
alias gst='git status'
alias gpush='git push'
alias gpull='git pull'

# This function takes in a list of files and a commit message
# Example: `gam . 'initial commit'` 
# Will add all files in the current directory and commit with the message 'initial commit'
gam() {
  for file in "${@:1:$#-1}"; do
    git add $file
  done
  git commit -m "${!#}"
}


# miscellaneous options -------------------------

# change directory AND list contents of the directory
cdl() {
	cd "$@";
	ls -alhF;
}

# human readable file & directory
alias ls='ls -alh --color=auto'

# get date & time now
alias now='date +%F\ %T'

# get the weather
alias weather='curl wttr.in/Dallas?0'
