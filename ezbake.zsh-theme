setopt prompt_subst


# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' | sed -n -E 's/(([A-Z]+-[0-9]*)|(master)).*/\1/p'`
  if [[ -z "${BRANCH}" ]]
  then
    echo ""
  else
    STAT=`parse_git_dirty`
    echo " [${BRANCH}${STAT}]"
  fi
}

# get current status of git repo
function parse_git_dirty {
  gstatus=`git status 2>&1 | tee`
  dirty=`echo -n "${gstatus}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${gstatus}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${gstatus}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${gstatus}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${gstatus}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${gstatus}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" = "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" = "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" = "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" = "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" = "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" = "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" = "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

PROMPT="%f[%F{45}%D{%a} %F{227}%D{%Y-%m-%d} %F{45}%D{%H:%M:%S}%f] %B%n%b@%m:%F{33}%d%f $ "
RPROMPT='%F{13}$(parse_git_branch)%f'
