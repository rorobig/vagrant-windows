# Bootstrap is needed for installing core modules
Write-Output "Bootstrap: installing required DSC modules..."

# Install NuGet provider if missing
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -Force
}

# Install xActiveDirectory if missing
if (-not (Get-Module -ListAvailable -Name xActiveDirectory)) {
    Install-Module -Name xActiveDirectory -Force -Confirm:$false
}


Write-Output "Bootstrap: installing required DSC modules..."

# Ensure NuGet provider is available
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force


