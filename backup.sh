#!/bin/bash
# Backup multiple Routerboard devices to local script files.
#
# Author: Jacob McDonald.
# Revision: 181129a.
#
# Requirements:
# 1. Local bash shell.
# 2. Local SSH client.
# 3. SSH service enabled and reachable on Routerboard devices.
# 4. SSH private key, without password, installed on the local host.
# 5. SSH public key installed for a user on the Routerboard devices.
# 6. Routerboard device user must have permission to run '/export'.
# 7. Optional: install into crontab for saving the backups routinely.

# IPs of Routerboards to backup with the SSH public key installed.
ip='172.16.42.1 172.16.42.2 172.16.42.3 172.16.42.4 172.16.42.5 172.16.44.1'

# SSH user of the remote host.
user='yottabit'

# Path to store the saved config scripts. Use '.' for present directory.
save_path='/mnt/vol1/jacob.mcdonald/jacob.mcdonald/Backups/Routerboards'

# Avoids the accept certificate prompt, and never uses the saved certificates.
# The latter part avoids the security warning that would be presented with the
# host SSH key changes.
ssh_opts='-oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'

for ip in ${ip}; do
  ssh ${ssh_opts} ${user}@${ip} /export > "${save_path}/${ip}_$(date +%s).rsc"
done
