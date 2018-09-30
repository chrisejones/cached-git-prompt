__find_git_root()
{
  local repo="${_GITBRANCH_LAST_REPO-}"
  local gitdir=""
  [[ ! -z "$repo" ]] && gitdir="$repo/.git"

  found=false
  # If we don't have a last seen git repo, or we are in a different directory
  if [[ -z "$repo" || "$PWD" != "$repo"* || ! -e "$gitdir" ]]; then
    local cur="$PWD"
    while [[ ! -z "$cur" ]]; do
      if [[ -e "$cur/.git" ]]; then
        repo="$cur"
        gitdir="$cur/.git"
        found=true
        break
      fi
      cur="${cur%/*}"
    done
  fi

  if [[ $found == false ]]; then
    unset _GITBRANCH_LAST_REPO
    return 1
  fi
  export _GITBRANCH_LAST_REPO="${repo}"
  echo "$repo"
  return 0
}

cached_git_info() {
  local git_root=$(__find_git_root)

  if [[ $? != 0 ]]; then
    return 0
  fi

  local prompt_git_info="$git_root/.prompt_git_info.txt"
  if [[ ! -e "$prompt_git_info" ]]; then
    return 0
  fi

  echo -n " "
  cat "$prompt_git_info"
  return 0
}
