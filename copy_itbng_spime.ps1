# Copy working spimeengine.js from itbng to indigo-lb
# This version handles local images correctly

Write-Host "Copying working spimeengine.js from itbng..." -ForegroundColor Cyan

$source = "..\itbng\assets\js\spimeengine.js"
$destination = "assets\js\spimeengine.js"

if (Test-Path $source) {
    Copy-Item $source $destination -Force
    Write-Host "[OK] Copied itbng's working spimeengine.js"  -ForegroundColor Green
    Write-Host ""
    Write-Host "Now refresh browser at https://127.0.0.1:9000" -ForegroundColor Yellow
    Write-Host "Press Ctrl+Shift+R for hard refresh" -ForegroundColor Yellow
} else {
    Write-Host "[ERROR] Source file not found: $source" -ForegroundColor Red
}
