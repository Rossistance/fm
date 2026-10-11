#!/bin/bash
# FamiliOS: one-time setup so Claude can reach this Mac over SSH (and run admin commands without asking again).
KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKqq3bT522kwywvDG1fUAHzw4IGpO++lwcq+A2/7ygn familios-claude'
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
grep -qF "$KEY" "$HOME/.ssh/authorized_keys" 2>/dev/null || echo "$KEY" >> "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
echo
echo ">>> Type YOUR MAC LOGIN PASSWORD when asked (it stays on this Mac)."
sudo -v || exit 1
sudo systemsetup -setremotelogin on >/dev/null 2>&1
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist >/dev/null 2>&1
sudo dseditgroup -o edit -a "$USER" -t user com.apple.access_ssh >/dev/null 2>&1
sudo mkdir -p /etc/sudoers.d && echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/familios >/dev/null && sudo chmod 440 /etc/sudoers.d/familios
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
echo
echo "=================================================="
echo " DONE. Tell Claude:  user=$USER  ip=$IP"
echo "=================================================="
