## path modifications
export PATH="$HOME/Applications/GoLand.app/Contents/MacOS:$HOME/Applications/PyCharm.app/Contents/MacOS:$HOME/Applications/Rider.app/Contents/MacOS:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.platformio/penv/bin:$PATH"

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

## homebrew configs
# install things to user directory
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"
# dont autoupdate homebrew on every run
export HOMEBREW_AUTO_UPDATE_SECS=604800

# global pip install w/o active venv
gpip(){
    PIP_REQUIRE_VIRTUALENV="0" python -m pip "$@"
}

# greenlight go project
export GREENLIGHT_DB_DSN="postgres://greenlight:password123@localhost:5432/greenlight?sslmode=disable"

# source stuff
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# custom aliases
alias ll="ls -lha"

alias gs="git status"
alias gps="git push"
alias gpl="git pull"
alias gcm="git commit -m"
alias gwl="git worktree list"
alias gwrm="git worktree remove --force"
alias gwr="git worktree repair"
alias gwp="git worktree prune"

alias newts="npm init -y && npm i -D typescript ts-node eslint prettier @types/node && npx tsc --init"

alias newresume="docker run --rm -v /Users/nq/Documents/cv/yml:/home/yamlresume yamlresume/yamlresume new"
alias buildresume="docker run --rm -v /Users/nq/Documents/cv/yml:/home/yamlresume yamlresume/yamlresume build"

alias lzd='lazydocker'

# custom functions
gcw() {
    if [ -z "$1" ]; then
        echo "Usage: gcw <git-url> [directory-name]"
        echo "Example: gcw git@github.com:nqui/myrepo.git my-project"
        return 1
    fi

    local repo_url="$1"
    local dir_name="$2"

    if [ -z "$dir_name" ]; then
        dir_name=$(basename "$repo_url" .git)
    fi

    echo "📦 Cloning $repo_url into $dir_name/.bare"
    git clone --bare "$repo_url" "$dir_name/.bare"

    if [ $? -eq 0 ]; then
        cd "$dir_name"
        echo "gitdir: ./.bare" > .git
        touch .env.shared
        mkdir -p .claude
        echo "✅ Done! Created $dir_name with bare repo"
        echo ""
        echo "Dont forget to add env vars to .env.shared"
        echo ""
        echo "gwa main main"
    else
        echo "❌ Clone failed"
        return 1
    fi
}

gwa() {
    if [ -z "$1" ]; then
        echo "Usage: gwa <dir> [branch]"
        return 1
    fi

    local dir="$1"
    local branch="${2:-$1}"

    if git show-ref --verify --quiet "refs/heads/$branch" || \
        git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        git worktree add "$dir" "$branch"
    else
        echo "Branch '$branch' not found, creating with -b"
        git worktree add -b "$branch" "$dir"
    fi

    if [ $? -eq 0 ]; then
        [ -f .env.shared ] && ln -s ../.env.shared "$dir/.env" && echo "🔗 symlinked .env.shared -> $dir/.env"
        [ -d .claude ] && ln -s ../.claude "$dir/.claude" && echo "🔗 symlinked .claude -> $dir/.claude"
    fi
}

# mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

# pnpm
export PNPM_HOME="/Users/nq/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# starship.rs
eval "$(starship init zsh)"
