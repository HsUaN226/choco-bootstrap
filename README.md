# Chocolatey Bootstrap Repository

This repository provides a streamlined way to install and manage Chocolatey packages using PowerShell scripts. It is designed to simplify the setup of development, core, and optional tools on a Windows system.

## Features
- **Manage Packages**: Use `packages-manager.ps1` to install or update packages listed in configuration files.
- **Customizable Configurations**: Organize packages into categories (e.g., core, dev, optional) for better management.

## Usage

### Prerequisites
- **Administrator Privileges**: Run the script as an administrator.
- **PowerShell**: Ensure PowerShell is installed and accessible.

### Manage Packages
1. Open PowerShell as Administrator.
2. Navigate to the repository directory:
   ```powershell
   cd c:\Users\yuhsuanlin\tools\choco-bootstrap
   ```
3. Run the script:
   ```powershell
   .\packages-manager.ps1
   ```
4. Follow the prompts to select an action (install or update) and a configuration file.

## Adding Packages
To add packages, edit the appropriate configuration file in the `packages/` directory. List one package per line. For example:
```
git
vscode
nodejs
```

## Backup Installed Packages
To back up currently installed packages, run:
```powershell
choco list --local-only > backup-packages.config
```

## License
This repository is open-source and available under the MIT License.