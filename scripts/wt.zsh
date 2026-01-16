# Worktree picker - quickly cd to worktrees in current repo
# Usage: wt (from within any git repo)

wt() {
  local git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)

  if [[ -z "$git_common_dir" || "$git_common_dir" == ".git" ]]; then
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  else
    local repo_root=$(dirname "$git_common_dir")
  fi

  if [[ -z "$repo_root" ]]; then
    echo "Not in a git repository"
    return 1
  fi

  local worktrees_dir="$repo_root/.worktrees"

  if [[ ! -d "$worktrees_dir" ]]; then
    echo "No worktrees found in $(basename "$repo_root")"
    return 1
  fi

  local selected=$(
    for dir in "$worktrees_dir"/*/; do
      [[ -d "$dir" ]] || continue
      local name="${dir%/}"
      name="${name##*/}"
      echo "$name|${dir%/}"
    done \
    | fzf --delimiter='|' --with-nth=1 \
          --preview='git -C {2} log --oneline -5' \
          --header="$(basename "$repo_root") worktrees" \
    | cut -d'|' -f2
  )

  [[ -n "$selected" ]] && cd "$selected"
}
