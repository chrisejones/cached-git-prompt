# cached-git-prompt
Git wrapper script for writing information to be displayed in a Bash prompt

## Introduction
Many custom Bash prompts shell out to Git to populate information about the Git repository in the current working directory, but in some environments shelling out to external commands is relatively slow and makes the prompt feel laggy.

This project takes an alternative approach. We wrap Git in a script that works out the repository directory of the executed command and caches information to be rendered in the prompt.

## Usage
Minimal example of what to add to your .bashrc

```bash
CACHED_GIT_INFO_DIRECTORY="$HOME/git/cached-git-prompt"

source "$CACHED_GIT_INFO_DIRECTORY/cached_git_prompt.bash"
alias git="$CACHED_GIT_INFO_DIRECTORY/git-prompt-info-wrapper"

ORIG_PS1=$PS1

# Prepend git info to your existing prompt
ps1() {
  git_info=$(cached_git_info)
  if [[ -z $git_info ]]; then
    PS1="$ORIG_PS1"
  else
    PS1="$git_info $ORIG_PS1"
  fi
}

PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
```

We recommend that you add the file that's used to cache Git information to a global Git ignore list.
```bash
echo ".prompt_git_info.txt" > ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
```
