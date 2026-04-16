# swiggster — one-command installer for Claude Code (Windows PowerShell)
# Usage: irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex

$ErrorActionPreference = "Stop"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: 'node' is required. Install from https://nodejs.org and re-run." -ForegroundColor Red
    exit 1
}

$Settings = Join-Path $env:USERPROFILE ".claude\settings.json"

if (-not (Test-Path $Settings)) {
    New-Item -ItemType Directory -Path (Split-Path $Settings) -Force | Out-Null
    Set-Content -Path $Settings -Value "{}"
}

Copy-Item $Settings "$Settings.bak" -Force

$env:SWIGGSTER_SETTINGS = $Settings -replace '\\', '/'

$nodeScript = @'
const fs = require('fs');
const path = process.env.SWIGGSTER_SETTINGS;
const s = JSON.parse(fs.readFileSync(path, 'utf8'));

if (!s.extraKnownMarketplaces) s.extraKnownMarketplaces = {};
s.extraKnownMarketplaces.swiggster = {
  source: { source: "github", repo: "sanskarsingh1-insta/swiggster" }
};

if (!s.enabledPlugins) s.enabledPlugins = {};
s.enabledPlugins["swiggster@swiggster"] = true;

fs.writeFileSync(path, JSON.stringify(s, null, 2) + "\n");
console.log("swiggster registered in settings.json");
'@

node -e $nodeScript

Write-Host ""
Write-Host "Done! Restart Claude Code to activate swiggster." -ForegroundColor Green
Write-Host "On next session start, Claude Code will download and activate the plugin automatically."
