# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.

test -s ~/.alias && . ~/.alias || true

function ocr {
  wl-paste | tesseract - stdout 2>/dev/null | cat
}

function reset_gpu_cache {
  rm -rf ~/.config/Code/GPUCache
}

function sudo_keep_alive {
  sudo -v
  while true; do sudo -n true; sleep 10; done 2>/dev/null &
  pid=$!
}

function katedit {
  EDITOR="kate -b -n" sudoedit $1
}

function update_all {
  local pid=0
  sudo_keep_alive
  echo $pid
  sudo zypper dup --no-recommends -y
  flatpak upgrade -y
  flatpak uninstall --unused --delete-data
  rustup update
  distrobox upgrade --all
  if [[ "$1" == "s" ]]; then
    sudo shutdown now
  elif [[ "$1" == "r" ]]; then
    sudo reboot
  fi
  kill $pid 
}
