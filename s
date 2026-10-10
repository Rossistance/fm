#!/bin/bash
# FamiliOS: one-time setup so Claude can reach this Mac over SSH (run on the old MacBook Pro).
KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKqq3bT522kwywvDG1fUAHzw4IGpO++lwcq+A2/7ygn familios-claude'
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
grep -qF "$KEY" "$HOME/.ssh/authorized_keys" 2>/dev/null || echo "$KEY" >> "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
echo
echo ">>> Turning on Remote Login. Type YOUR MAC LOGIN PASSWORD when asked (it stays on this Mac)."
sudo systemsetup -setremotelogin on
sudo dseditgroup -o edit -a "$USER" -t user com.apple.access_ssh 2>/dev/null
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
echo
echo "=================================================="
echo " DONE. Tell Claude:  user=$USER  ip=$IP"
echo "=================================================="
