#!/usr/bin/env zsh

# allow sudo-able aliases
alias sudo="sudo "

# colorful ls
alias ls="ls -G --color=auto"
alias ll="ls -lah"
alias la="ls -a"
alias l="ll"

# easier dotfile tinkering
alias shreload="exec \$SHELL"

# git
alias g="git"
alias gc="git commit -m"               # + commit message
alias gca="git add . && git commit -m" # + commit message
alias gs="git status -sb"
alias gl="git log --pretty=short"
alias gd="git diff"
alias gds="git diff --staged"
alias gpom="git push origin main"
alias glom="git pull origin main"
alias gpo="git push origin" # + branch name
alias glo="git pull origin" # + branch name
alias glfm="git fetch && git reset origin/main --hard"
alias gb="git checkout"     # + existing branch name
alias gbn="git checkout -b" # + new branch name
alias grm="git rebase -i origin/main"
alias gsub="git submodule update --recursive --remote"
alias gundo="git reset --soft HEAD~1"
alias gres="git reset"
alias github="gh repo view --web"
alias gist="gh gist create --web"

# docker
alias dps="docker ps -a"
dbar() {
    # build and run:
    # https://stackoverflow.com/questions/45141402/build-and-run-dockerfile-with-one-command/59220656#59220656
    docker build --progress=plain --no-cache . | tee /dev/tty | tail -n1 | cut -d' ' -f3 | xargs -I{} docker run --rm -i {}
}
dsh() {
    docker exec -it "$1" /bin/sh
}
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr="docker compose down && docker compose up -d"
alias dcl="docker compose logs -f"

# multipass
alias mp="multipass"
mpl() {
    # creates VM and opens its bash shell
    # `mpl test1 4G 20.04`
    multipass launch "${2:-jammy}" --cpus 4 --mem "${3:-2G}" --disk 20G --name "$1" &&
        multipass shell "$1"
}
alias mpls="multipass list"
alias mpsh="multipass shell"
alias mpk="multipass stop"
alias mpd="multipass delete"

# Node/NPM/Yarn
alias npr="npm run"
alias fresh_npm="rm -rf node_modules package-lock.json && npm install"
alias fresh_yarn="rm -rf node_modules yarn.lock && yarn install"

# uncomment to use VS Code insiders build
# alias code="code-insiders"
# open current working directory in VS Code
alias vs="code ."

# an original creation, see https://github.com/jakejarvis/simpip
alias ipv4="curl -4 simpip.com --max-time 1 --proto-default https --silent"
alias ipv6="curl -6 simpip.com --max-time 1 --proto-default https --silent"
alias ip="ipv4; ipv6"
alias ip-local="ipconfig getifaddr en0"
alias ips="ip; ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# youtube-dl
alias youtube-dl="yt-dlp" # better youtube-dl fork: https://github.com/yt-dlp/yt-dlp
alias ytdl="youtube-dl -f bestvideo+bestaudio"
alias ytmp3="youtube-dl -f bestaudio -x --audio-format mp3 --audio-quality 320K"

# misc.
alias screenfetch="neofetch"
alias weather="curl 'https://wttr.in/?format=v2'"
