# Worktree picker - quickly cd to worktrees in current repo
# Usage: wt (from within any git repo)

wt() {
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

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
    fd -t d . "$worktrees_dir" --max-depth 1 \
    | while read -r path; do
        echo "$(basename "$path")|$path"
      done \
    | fzf --delimiter='|' --with-nth=1 \
          --preview='git -C {2} log --oneline -5' \
          --header="$(basename "$repo_root") worktrees" \
    | cut -d'|' -f2
  )

  [[ -n "$selected" ]] && cd "$selected"
}
