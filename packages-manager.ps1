# Combined Install and Update Script for Chocolatey Packages

# Ensure Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Prompt user to choose between install or update
Write-Output "What would you like to do?"
Write-Output "[1] Install packages"
Write-Output "[2] Update packages"
$action = Read-Host "Enter the number of your choice"

if ($action -eq 1) {
    Write-Output "You chose to install packages."
} elseif ($action -eq 2) {
    Write-Output "You chose to update packages."
} else {
    Write-Output "Invalid selection. Exiting."
    exit
}

# Prompt user to select a configuration file
$packageConfigs = Get-ChildItem -Path "packages" -Filter "*.config"
if ($packageConfigs.Count -eq 0) {
    Write-Output "No configuration files found in the packages directory."
    exit
}

Write-Output "Select a configuration file:"
for ($i = 0; $i -lt $packageConfigs.Count; $i++) {
    Write-Output "[$($i + 1)] $($packageConfigs[$i].Name)"
}

$selection = Read-Host "Enter the number of your choice"
if (-not ($selection -as [int]) -or $selection -lt 1 -or $selection -gt $packageConfigs.Count) {
    Write-Output "Invalid selection. Exiting."
    exit
}

$configFile = $packageConfigs[$selection - 1].FullName

# Perform the selected action
if ($action -eq 1) {
    Write-Output "Installing packages from $configFile..."
    Get-Content $configFile | ForEach-Object {
        choco install $_ -y
    }
} elseif ($action -eq 2) {
    Write-Output "Updating packages from $configFile..."
    Get-Content $configFile | ForEach-Object {
        choco upgrade $_ -y
    }
}