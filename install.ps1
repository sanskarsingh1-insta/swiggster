# swiggster installer
# Usage: irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex

# Step 1: Wire swiggster into ~/.claude/settings.json (no dependencies needed)
$settings = "$env:USERPROFILE\.claude\settings.json"
if (-not (Test-Path $settings)) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null
    '{}' | Set-Content $settings
}

$s = Get-Content $settings -Raw | ConvertFrom-Json

if (-not $s.extraKnownMarketplaces) {
    $s | Add-Member -NotePropertyName extraKnownMarketplaces -NotePropertyValue ([PSCustomObject]@{})
}
$s.extraKnownMarketplaces | Add-Member -NotePropertyName swiggster -NotePropertyValue ([PSCustomObject]@{
    source = [PSCustomObject]@{ source = "github"; repo = "sanskarsingh1-insta/swiggster" }
}) -Force

if (-not $s.enabledPlugins) {
    $s | Add-Member -NotePropertyName enabledPlugins -NotePropertyValue ([PSCustomObject]@{})
}
$s.enabledPlugins | Add-Member -NotePropertyName "swiggster@swiggster" -NotePropertyValue $true -Force

$s | ConvertTo-Json -Depth 10 | Set-Content $settings
Write-Host "Swiggster registered." -ForegroundColor Green

# Step 2: Node.js — needed for session-start hook (optional but recommended)
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "Node.js already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Node.js (no admin required)..." -ForegroundColor Yellow

    # Install via nvm-windows (no UAC needed)
    $nvmInstaller = "$env:TEMP\nvm-setup.exe"
    try {
        Invoke-WebRequest -Uri "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.exe" -OutFile $nvmInstaller -UseBasicParsing
        Start-Process $nvmInstaller -ArgumentList "/SILENT" -Wait
        # Refresh PATH
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("PATH","User")
        if (Get-Command nvm -ErrorAction SilentlyContinue) {
            nvm install lts
            nvm use lts
            Write-Host "Node.js installed via nvm." -ForegroundColor Green
        }
    } catch {
        Write-Host "Node.js install skipped (optional). Swiggster skill still works without it." -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Done. Restart Claude Code to activate swiggster." -ForegroundColor Green
