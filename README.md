# Automated script backup of RouterOS configurations.
## Backup multiple Routerboard devices to local script files.

### Requirements:
1. Local bash shell.
1. Local SSH client.
1. SSH service enabled and reachable on Routerboard devices.
1. SSH private key, without password, installed on the local host.
1. SSH public key installed for a user on the Routerboard devices.
1. Routerboard device user must have permission to run '/export'.
1. Optional: install into crontab for saving the backups routinely.
