# swiggster installer — no dependencies required
# Usage: irm https://raw.githubusercontent.com/sanskarsingh1-insta/swiggster/master/install.ps1 | iex

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

Write-Host "Done. Restart Claude Code to activate swiggster." -ForegroundColor Green
