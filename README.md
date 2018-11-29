# Automated script backup of RouterOS configurations.
## Backup multiple RouterOS devices to local script files.

### Requirements:
1. Local bash shell.
1. Local SSH client.
1. SSH service enabled and reachable on RouterOS devices.
1. SSH private key, without password, installed on the local host.
1. SSH public key installed for a user on the RouterOS devices.
1. RouterOS device user must have permission to run `/export`.
1. Local copy of `backup.sh` from this project.
1. Optional: install into crontab for saving the backups routinely.

### Instructions:
1. Download the `backup.sh` bash script from this project and store somewhere accessible by the local Unix user.
1. Edit the variables in the script as-needed.
   * var `ip` must contain a space-delimited list of all reachable IP addresses of RouterOS devices for backup.
   * var `user` must contain the username to use on the remote RouterOS devices. Ensure this user has permission to run the `/export` command.
   * var `save_path` must contain a path prefix to use when saving the backup scripts. A trailing slash is unnecessary, but allowed. Use `.` for the current directory.
   * var `ssh_opts` disables strict host certificate checking, and warnings for changed host certificates. You can remove this var if you desire stricter security, but you will need to login to the host interactively first (in order to save the host certificate), or add the host keys to the `~/.ssh/authorized_hosts` file manually.
1. If desired, change the timestamp format from unix seconds `+%s` to something else. Unix seconds allows for easy filename sorting, and the ctime of the file inode can still provide a more user-friendly date.
1. Create an RSA SSH keypair using `ssh-keygen -t rsa`. You should not specify a password (leave blank) in order to allow the SSH login to happen non-interactively.
   * _Note:_ RouterOS v6.29, or later, is required to use RSA keys; DSA keys were supported prior but are now considered weak/insecure.
   * _Note:_ never share the `id_rsa` SSH secret key file. This is essentially your password. Keep it secure. Likewise, backup the file to a secure location because if the file is lost, you will not be able to SSH into the RouterOS device user(s) using it unless you enable SSH password logins as noted below.
1. Copy the `id_rsa.pub` public SSH key file to RouterOS using Winbox, Webfib, or SFTP.
1. Import the key file for the desired user: _System_ -> _Users_ -> _SSH Keys_ -> _Import SSH Key_.
   * _Note:_ By default RouterOS disable password-logins for SSH whenever an SSH public key is present for the user. This means that after you have imported the key, you can no longer use SSH password logins for that user. To enable SSH password logins, run the following command from the terminal (it is not available in Winbox or Webfig): `/ip ssh set always-allow-password-login=yes`.
1. You can now perform backup script retrievals by running the shell script, `bash backup.sh`, or `./backup.sh` (if you have set the `+x` bit on the file).
1. Optionally you can install the script command into Unix crontab to run daily at midnight for the current user.
   * Run `crontab -e` and then add `0 0 * * * bash /path/to/backup.sh` to backup the RouterOS device.
   * Or run `(crontab -l 2> /dev/null; echo '0 0 * * * bash /path/to/backup.sh') | crontab -`.
   * Adjust the `0 0 * * *` to schedule more or less frequently than daily at midnight. See `man 5 crontab` for the scheduling syntax.
