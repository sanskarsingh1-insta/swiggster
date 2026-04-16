# swiggster installer
# Usage: irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex

$repo   = "sanskarsingh1-insta/swiggster"
$branch = "master"
$base   = "https://raw.githubusercontent.com/$repo/$branch"
$claude = "$env:USERPROFILE\.claude"

$files = @(
    ".claude-plugin/plugin.json",
    "skills/swiggster/SKILL.md",
    "hooks/swiggster-activate.js",
    "references/cross-domain-signals.md"
)

# 1. Download plugin files into marketplace + cache dirs
$hash = "a1b2c3d4e5f6"
$dirs = @(
    "$claude\plugins\marketplaces\swiggster",
    "$claude\plugins\cache\swiggster\swiggster\$hash"
)

foreach ($dir in $dirs) {
    foreach ($file in $files) {
        $dest = Join-Path $dir $file
        New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
        try {
            Invoke-WebRequest -Uri "$base/$file" -OutFile $dest -UseBasicParsing
        } catch {
            Write-Host "Warning: could not download $file" -ForegroundColor Yellow
        }
    }
}
Write-Host "Plugin files installed." -ForegroundColor Green

# 2. Wire into ~/.claude/settings.json
$settings = "$claude\settings.json"
if (-not (Test-Path $settings)) {
    New-Item -ItemType Directory -Path $claude -Force | Out-Null
    '{}' | Set-Content $settings
}

$s = Get-Content $settings -Raw | ConvertFrom-Json

if (-not $s.extraKnownMarketplaces) {
    $s | Add-Member -NotePropertyName extraKnownMarketplaces -NotePropertyValue ([PSCustomObject]@{})
}
$s.extraKnownMarketplaces | Add-Member -NotePropertyName swiggster -NotePropertyValue ([PSCustomObject]@{
    source = [PSCustomObject]@{ source = "github"; repo = $repo }
}) -Force

if (-not $s.enabledPlugins) {
    $s | Add-Member -NotePropertyName enabledPlugins -NotePropertyValue ([PSCustomObject]@{})
}
$s.enabledPlugins | Add-Member -NotePropertyName "swiggster@swiggster" -NotePropertyValue $true -Force

$s | ConvertTo-Json -Depth 10 | Set-Content $settings
Write-Host "settings.json updated." -ForegroundColor Green

# 3. Node.js (needed for session-start hook — optional)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js via nvm (no admin required)..." -ForegroundColor Yellow
    $nvmInstaller = "$env:TEMP\nvm-setup.exe"
    try {
        Invoke-WebRequest -Uri "https://github.com/coreybutler/nvm-windows/releases/latest/download/nvm-setup.exe" -OutFile $nvmInstaller -UseBasicParsing
        Start-Process $nvmInstaller -ArgumentList "/SILENT" -Wait
        $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                    [System.Environment]::GetEnvironmentVariable("PATH","User")
        if (Get-Command nvm -ErrorAction SilentlyContinue) {
            nvm install lts | Out-Null
            nvm use lts   | Out-Null
            Write-Host "Node.js installed." -ForegroundColor Green
        }
    } catch {
        Write-Host "Node.js install skipped (optional)." -ForegroundColor Cyan
    }
} else {
    Write-Host "Node.js already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Done. Restart Claude Code to activate swiggster." -ForegroundColor Green
