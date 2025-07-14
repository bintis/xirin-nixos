# Xirin NixOS Configuration

Built on ZaneyOS but with Cosmic-DE

Removed a lot of the unneeded packages for me self and added some that I use such as fcitx5 for Chinese and Japanese input.

## Installation

Removed the install script and replaced it with a simple flake.
Remember to generate the hardware configuration file with `sudo nixos-generate-config` into the `hosts/hostname` directory.

## Network Mounts

### SMB Mounts

The system is configured to mount SMB shares from a TrueNAS server. For security, credentials are stored in a separate file outside the Git repository.

1. Create a credentials file at `~/.config/nixos-secrets/smb-credentials` with the following format:
   ```
   username=your_username
   password=your_password
   ```

2. Secure the file with proper permissions:
   ```bash
   chmod 600 ~/.config/nixos-secrets/smb-credentials
   ```

3. For public repositories, replace the actual server IP in `modules/core/smb-mount.nix` with a placeholder before committing.

4. The SMB mounts are configured in `modules/core/smb-mount.nix` and will automatically mount when accessed at:
   - `~/Drive/Disk1`
   - `~/Drive/Disk2`
   - `~/Drive/Disk3`

### Rclone Mounts

The system also supports rclone mounts for cloud storage services, configured in `modules/core/rclone-mount.nix`.

Then you can use  cmd like`sudo nixos-rebuild switch --flake .#amd` to apply the changes.