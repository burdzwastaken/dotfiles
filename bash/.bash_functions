#!/usr/bin/env bash
#------------------------------------------------------------------------------
# File:   $HOME/.bash_functions
# Author: Matt Burdan <burdz@burdz.net>
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# bash functions
#------------------------------------------------------------------------------

extract() { # extract files.
    local x
    ee() { # echo and execute
        echo "$@"
        $1 "$2"
    }
    for x in "$@"; do
        if [ -f "$x" ] ; then
            case "$x" in
                *.tar.bz2 | *.tbz2 ) ee "tar xvjf" "$x"   ;;
                *.tar.gz | *.tgz )   ee "tar xvzf" "$x"   ;;
                *.bz2 )              ee "bunzip2" "$x"    ;;
                *.rar )              ee "unrar x" "$x"    ;;
                *.gz )               ee "gunzip" "$x"     ;;
                *.tar )              ee "tar xvf" "$x"    ;;
                *.zip )              ee "unzip" "$x"      ;;
                *.Z )                ee "uncompress" "$x" ;;
                *.7z )               ee "7z x" "$x"       ;;
		* )                  echo "'$1' cannot be extracted via extract()"
            esac
        else
	    echo "'$1' is not a valid file for extraction!"
	fi
    done
}

sshrc() {
    scp ~/.bashrc "$1":/tmp/.bashrc_temp
    ssh -t "$@" "bash --rcfile /tmp/.bashrc_temp ; rm /tmp/.bashrc_temp"
}

dockerrm() {
    docker rm -v "$(docker ps --filter status=exited -q 2>/dev/null)" 2>/dev/null
    docker rmi "$(docker images --filter dangling=true -q 2>/dev/null)" 2>/dev/null
}

docker-clean() {
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock zzrot/docker-clean "$@"
}

chromepdf() {
    chrome --headless --disable-gpu --print-to-pdf="$1" "$2"
}

# shellcheck disable=SC2009
mem() {
    ps -eo rss,pid,euser,args:100 --sort %mem | grep -v grep | grep -i "$@" | awk '{printf $1/1024 "MB"; $1=""; print }'
}

log() {
    logger -i -t "$0" "$@"
    echo "$($$)" "$(date)": "$@"
}

# requires sudo due to folder perms
bigfilez() {
    sudo find "$@" -type f -size +10M -exec ls -lh {} \;
}

go-dep-imports() {
    go list -f '{{join .Deps "\n"}}' "$@"
}

statuscode() {
    curl -s -o /dev/null -w "%{http_code}" "$@"
}

upgrade-kubectl() {
    curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/"$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl && chmod +x /tmp/kubectl && mv /tmp/kubectl /usr/local/bin/
}

upgrade-minikube() {
    curl -Lo /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x /tmp/minikube && mv /tmp/minikube /usr/local/bin/
}

getcertnames() {
    local tmp
    local certText
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
    fi;
    local domain="${1}";
    echo "Testing ${domain}…";
    echo ""; # newline
    tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
	| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);
    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        certText=$(echo "${tmp}" \
            | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
            no_serial, no_sigdump, no_signame, no_validity, no_version");
	echo "Common Name:";
	echo ""; # newline
	echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\\/emailAddress=.*//";
	echo ""; # newline
	echo "Subject Alternative Name(s):";
	echo ""; # newline
	echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
            | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2;
	return 0;
    else
	echo "ERROR: Certificate not found.";
	return 1;
    fi;
}

# find a file with a pattern in name:
function ff() {
    find . -type f -iname '*'"$*"'*' -ls ;
}

# find a directory with a pattern in name:
function fd() {
    find . -type d -iname '*'"$*"'*' -ls ;
}

# create folder then cd into it
function mkcd() {
    mkdir -p "$@"; cd "$@" || exit
}

function passgen() {
    < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c"$*"
}

function up(){
    DEEP="$1";
    for _ in $(seq 1 "${DEEP:-"1"}");
        do cd ../ || exit;
    done;
}

function del-via-inode() {
    find . -inum "$@" -exec rm -i {} \;
}

function ssh-htop() {
    ssh "$@" -t 'htop'
}

function dirreplace() {
    # find $(pwd) -type f -print0 | xargs -0 sed -Ei $@
    find ./ -type f -exec sed -i -e "$@" {} \;
}

function tarsend() {
    # tar -c $@ | nc -l -p 1337
    tar -zcvf "$@" | nc -q 10 -l -p 1337
}

function tarrcv() {
    nc -w 10 "$1" 1337 > "$2".tar
}

function kevents() {
    kubectl -n "$@" get events --sort-by=.metadata.creationTimestamp
}

function ketcdmetrics() {
    kubectl get --raw /metrics | grep ^etcd | grep object
}

function blockextract() {
    # Usage: extract file "opening marker" "closing marker"
    while IFS=$'\n' read -r line; do
        [[ $extract && $line != "$3" ]] &&
            printf '%s\n' "$line"

        [[ $line == "$2" ]] && extract=1
        [[ $line == "$3" ]] && extract=
    done < "$1"
}

function cidrnotation() {
    echo "2^(32-$1)" | bc
}

# c map
# LESS_TERMCAP_mb=$'\e[1;31m' \     # begin bold
# LESS_TERMCAP_md=$'\e[1;33m' \     # begin blink
# LESS_TERMCAP_so=$'\e[01;44;37m' \ # begin reverse video
# LESS_TERMCAP_us=$'\e[01;37m' \    # begin underline
# LESS_TERMCAP_me=$'\e[0m' \        # reset bold/blink
# LESS_TERMCAP_se=$'\e[0m' \        # reset reverse video
# LESS_TERMCAP_ue=$'\e[0m' \        # reset underline
# less with more
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
function man() {
    LESS_TERMCAP_mb=$'\e[1;31m' \
    LESS_TERMCAP_md=$'\e[1;33m' \
    LESS_TERMCAP_so=$'\e[01;44;37m' \
    LESS_TERMCAP_us=$'\e[01;37m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    command man "$@"
}
