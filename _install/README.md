# Nautilus Scripts for Firefox Reinstallation

This documentation covers the usage of two Nautilus scripts designed to uninstall the existing Firefox browser and install a new version, while preserving the user profile.

## Scripts

1. **tarball-sudo.sh**: This script initiates the process, handling the path to the Firefox tarball and calling the second script with elevated privileges.

2. **_tarball.sh**: This script performs the actual uninstallation of the existing Firefox version and installs the new version from the provided tarball.

## Usage

### Preparing the Scripts

1. Place both scripts in a suitable directory, such as `~/Scripts`.

2. Ensure the scripts are executable:
   ```bash
   chmod +x tarball-sudo.sh
   chmod +x _tarball.sh
   ```

3. Modify `tarball-sudo.sh` to include the absolute path to `_tarball.sh`.

### Running the Scripts

1. Navigate to the directory containing the Firefox tarball.

2. Run `tarball-sudo.sh` with the tarball filename:
   ```bash
   ./tarball-sudo.sh firefox-120.0.tar.bz2
   ```

   Replace `firefox-120.0.tar.bz2` with the actual name of your Firefox tarball.

### Notes

- The scripts assume that the tarball is named in a specific format (e.g., `firefox-120.0.tar.bz2`).
- `tarball-sudo.sh` will prompt for the sudo password via a graphical interface (pkexec).
- Ensure that the tarball path is correct and accessible by the script.

## Troubleshooting

If you encounter issues:

- Check the absolute path in `tarball-sudo.sh`.
- Ensure both scripts are executable and have the correct permissions.
- Verify that the tarball file exists and is in the expected location.
- Check the log files if you've implemented logging for debugging purposes.

---

For more information or support, refer to the script comments or contact the script maintainer.
