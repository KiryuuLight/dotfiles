#!/usr/bin/env bash
# Claude Code Statusline - Catppuccin Mocha Blue

input=$(cat)

# -- Colors (Catppuccin Mocha true color) --
c_blue=$'\x1b[38;2;137;180;250m'
c_sapphire=$'\x1b[38;2;116;199;236m'
c_lavender=$'\x1b[38;2;180;190;254m'
c_subtext=$'\x1b[38;2;166;173;200m'
c_overlay=$'\x1b[38;2;108;112;134m'
c_green=$'\x1b[38;2;166;227;161m'
c_yellow=$'\x1b[38;2;249;226;175m'
c_peach=$'\x1b[38;2;250;179;135m'
c_red=$'\x1b[38;2;243;139;168m'
c_mauve=$'\x1b[38;2;203;166;247m'
c_rst=$'\x1b[0m'
c_bold=$'\x1b[1m'

# -- Icons (nerd font unicode escapes) --
icon_model=$'\U000f06a9'   # 󰚩 robot
icon_branch=$'\Ue0a0'      #  branch
icon_folder=$'\Uf07b'      #  folder
icon_cost=$'\Uf155'        #  dollar

sep="${c_overlay} | ${c_rst}"

# -- Parse JSON --
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dirname=$(basename "$dir")
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')


# -- Model --
echo -n "${c_blue}${c_bold}${icon_model} ${model}${c_rst}"

# -- Git branch + PR --
if git rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    pr_num=$(gh pr view --json number -q '.number' 2>/dev/null)
    echo -n "${sep}${c_mauve}${icon_branch} ${branch}${c_rst}"
    if [ -n "$pr_num" ]; then
      echo -n " ${c_sapphire}#${pr_num}${c_rst}"
    fi
  fi
fi

# -- Context usage --
if [ -n "$remaining" ] && [ -n "$ctx_size" ]; then
  rem=${remaining%.*}
  used=$((100 - rem))
  scaled=$(( used * 100 / 80 ))
  [ "$scaled" -gt 100 ] && scaled=100

  used_k=$(( ctx_size * used / 100000 ))

  if [ "$ctx_size" -ge 1000000 ]; then
    total_fmt="1M"
  else
    total_fmt="$((ctx_size / 1000))k"
  fi

  filled=$(( scaled * 8 / 100 ))
  bar=""
  for ((i=0; i<8; i++)); do
    [ $i -lt $filled ] && bar="${bar}█" || bar="${bar}░"
  done

  if [ "$scaled" -lt 50 ]; then
    ctx_c="$c_green"
  elif [ "$scaled" -lt 70 ]; then
    ctx_c="$c_yellow"
  elif [ "$scaled" -lt 90 ]; then
    ctx_c="$c_peach"
  else
    ctx_c="$c_red"
  fi

  echo -n "${sep}${ctx_c}${bar} ${used_k}k/${total_fmt}${c_rst}"
fi

# -- Directory --
echo -n "${sep}${c_lavender}${icon_folder} ${dirname}${c_rst}"

# -- Git stats (files changed, insertions, deletions) --
if git rev-parse --git-dir > /dev/null 2>&1; then
  stats=$(git diff --shortstat 2>/dev/null)
  staged=$(git diff --cached --shortstat 2>/dev/null)
  # Combine staged + unstaged
  files=0; ins=0; del=0
  for s in "$stats" "$staged"; do
    [ -z "$s" ] && continue
    f=$(echo "$s" | grep -oP '\d+(?= file)') && files=$((files + f))
    i=$(echo "$s" | grep -oP '\d+(?= insertion)') && ins=$((ins + i))
    d=$(echo "$s" | grep -oP '\d+(?= deletion)') && del=$((del + d))
  done
  if [ "$files" -gt 0 ]; then
    echo -n "${sep}${c_subtext}${files} files${c_rst}"
    [ "$ins" -gt 0 ] && echo -n " ${c_green}+${ins}${c_rst}"
    [ "$del" -gt 0 ] && echo -n " ${c_red}-${del}${c_rst}"
  fi
fi

# -- Rate limits (Pro/Max only) --
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

if [ -n "$five_h" ]; then
  five_h_int=${five_h%.*}

  if [ "$five_h_int" -lt 50 ]; then
    lim_c="$c_green"
  elif [ "$five_h_int" -lt 75 ]; then
    lim_c="$c_yellow"
  elif [ "$five_h_int" -lt 90 ]; then
    lim_c="$c_peach"
  else
    lim_c="$c_red"
  fi

  echo -n "${sep}${lim_c}5h: ${five_h_int}% used${c_rst}"
fi

# -- Cost --
if [ -n "$cost" ] && [ "$cost" != "0" ]; then
  cost_fmt=$(printf '%.2f' "$cost")
  echo -n "${sep}${c_subtext}${icon_cost} ${cost_fmt}${c_rst}"
fi
