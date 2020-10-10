PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

################################################################

# systemctl shortcuts
# alias start='sudo systemctl start'
# alias stop='sudo systemctl stop'
# alias restart='sudo systemctl restart'
# alias status='systemctl status'
# alias enable='sudo systemctl enable'
# alias disable='sudo systemctl disable'

# colored output
alias dir='dir --color=auto'
alias egrep='egrep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='egrep --color'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias vdir='vdir --color=auto'

### https://gist.github.com/k4yt3x/162a7419e58a60ab774b65318179601b
# ipa prints distilled output of the "ip a" command
# version 1.3.0
alias ip4a="ipa -4"
alias ip6a="ipa -6"
function ipa() {
    python3 - $@ << EOF
import contextlib, json, subprocess, sys
e = ['ip', '-j', 'a']
if len(sys.argv) >= 2 and sys.argv[1] in ['-4', '-6']:
    e.insert(2, sys.argv[1])
elif len(sys.argv) >= 2:
    e.extend(['s', sys.argv[1]])
s = subprocess.Popen(e, stdout=subprocess.PIPE)
j = s.communicate()[0]
sys.exit(s.returncode) if s.returncode != 0 else None
for i in json.loads(j):
    with contextlib.suppress(Exception):
        print('{}: {}'.format(i['ifindex'], i['ifname']))
        print('    State: {}'.format(i['operstate'])) if i.get('operstate') and i.get('operstate') != 'UNKNOWN' else None
        print('    MAC: {}'.format(i['address'])) if i.get('address') else None
        print('    MAC (Permanent): {}'.format(i['permaddr'])) if i.get('permaddr') else None
        for a in i['addr_info']:
            family = 'IPv4' if a['family'] == 'inet' else a['family']
            family = 'IPv6' if a['family'] == 'inet6' else family
            print('    {}: {}/{}'.format(family, a['local'], a['prefixlen']))
EOF
}

################################################################

# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
alias mkdir='mkdir -p'
alias crontab='crontab -i'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias pip3='python3 -m pip'

alias hig='history | grep -i'
alias pig='ps aux | grep -i'
alias get_whatever_pw='pwgen -cnsy1 -H <(openssl rand -base64 2048)'
alias get_easyread_pw='pwgen -Bcnsy1 -r :\`\"\\/@'"\'"' -H <(openssl rand -base64 2048)'
alias get_easymemo_pw='pwgen -cn1 -H <(openssl rand -base64 2048)'
# alias curl='curl --doh-url https://dns.nextdns.io/dnscrypt-proxy --false-start --http2 --tlsv1.2'
curl() {
  $(type -P curl) -Lq --retry 5 --retry-delay 10 --retry-max-time 60 "$@"
}
# alias wget='wget2 --progress=bar --secure-protocol=PFS --https-enforce=soft'
alias diff='diff -y --suppress-common-lines'
alias checkinstall='checkinstall --nodoc'

mcd() { mkdir "$1"; cd "$1" || exit 1; }
md5check() { md5sum "$1" | grep "$2"; }
sha1check() { sha1sum "$1" | grep "$2"; }
sha256check() { sha256sum "$1" | grep "$2"; }
sha512check() { sha512sum "$1" | grep "$2"; }

git_clone() {
  if [[ -z "$GIT_PROXY" ]]; then
    git clone -j$(nproc) --no-tags --shallow-submodules --recurse-submodules --depth 1 --single-branch "$@"
  else
    git -c "$GIT_PROXY" clone -j$(nproc) --no-tags --shallow-submodules --recurse-submodules --depth 1 --single-branch "$@"
  fi
}

ghclone() {
  mkdir -p /github/
  cd /github/ || exit 1
  if [[ "$#" -eq '2' ]]; then
    git_clone "https://github.com/$1/$2.git"
    cd "$2" || exit 1
  elif [[ "$#" -eq '1' ]]; then
    git_clone "https://github.com/$1.git"
    IFS='/' tmp_array=($1)
    cd "${tmp_array[1]}" || exit 1
    unset tmp_array
  else
    echo 'error: Please enter the correct parameters.'
    exit 1
  fi
}

extract() {
    if [ -f "$1" ] ; then
        bsdtar -xf "$1"
    else
        echo "'$1' is not a valid file"
    fi
}
