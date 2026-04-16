# swiggster installer — zero admin required
# Usage: irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex

$repo   = "sanskarsingh1-insta/swiggster"
$branch = "master"
$base   = "https://raw.githubusercontent.com/$repo/$branch"
$claude = "$env:USERPROFILE\.claude"

# ── 1. Node.js portable (no admin, no UAC) ──────────────────────────────────
$nodeDir = "$env:USERPROFILE\.node"
if (-not (Get-Command node -ErrorAction SilentlyContinue) -and -not (Test-Path "$nodeDir\node.exe")) {
    Write-Host "Installing Node.js (portable, no admin)..." -ForegroundColor Yellow
    $zip = "$env:TEMP\node-portable.zip"
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v22.15.0/node-v22.15.0-win-x64.zip" -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath "$env:TEMP\node-extract" -Force
    if (Test-Path $nodeDir) { Remove-Item $nodeDir -Recurse -Force }
    Move-Item "$env:TEMP\node-extract\node-v22.15.0-win-x64" $nodeDir
    $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notlike "*$nodeDir*") {
        [System.Environment]::SetEnvironmentVariable("PATH", "$nodeDir;$userPath", "User")
    }
    $env:PATH = "$nodeDir;$env:PATH"
    Write-Host "Node.js installed." -ForegroundColor Green
} else {
    Write-Host "Node.js already available." -ForegroundColor Green
}

# ── 2. Download plugin files to cache + marketplace ─────────────────────────
$files = @(
    ".claude-plugin/plugin.json",
    "skills/swiggster/SKILL.md",
    "hooks/swiggster-activate.js",
    "references/cross-domain-signals.md"
)
$hash = "a1b2c3d4e5f6"
$dirs = @(
    "$claude\plugins\marketplaces\swiggster",
    "$claude\plugins\cache\swiggster\swiggster\$hash"
)

foreach ($dir in $dirs) {
    foreach ($file in $files) {
        $dest = Join-Path $dir $file
        New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null
        Invoke-WebRequest -Uri "$base/$file" -OutFile $dest -UseBasicParsing -ErrorAction SilentlyContinue
    }
}
Write-Host "Plugin files installed." -ForegroundColor Green

# ── 3. Wire into settings.json ───────────────────────────────────────────────
$settings = "$claude\settings.json"
if (-not (Test-Path $settings)) {
    New-Item -ItemType Directory -Path $claude -Force | Out-Null
    '{}' | Set-Content $settings
}
$s = Get-Content $settings -Raw | ConvertFrom-Json
if (-not $s.extraKnownMarketplaces) { $s | Add-Member -NotePropertyName extraKnownMarketplaces -NotePropertyValue ([PSCustomObject]@{}) }
$s.extraKnownMarketplaces | Add-Member -NotePropertyName swiggster -NotePropertyValue ([PSCustomObject]@{
    source = [PSCustomObject]@{ source = "github"; repo = $repo }
}) -Force
if (-not $s.enabledPlugins) { $s | Add-Member -NotePropertyName enabledPlugins -NotePropertyValue ([PSCustomObject]@{}) }
$s.enabledPlugins | Add-Member -NotePropertyName "swiggster@swiggster" -NotePropertyValue $true -Force
$s | ConvertTo-Json -Depth 10 | Set-Content $settings
Write-Host "settings.json updated." -ForegroundColor Green

Write-Host ""
Write-Host "Done! Restart Claude Code to activate swiggster." -ForegroundColor Green
