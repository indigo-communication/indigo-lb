# Restore original HTML and apply ONLY essential fixes
# No script changes, no size parameter removal - just localization

Write-Host "Step 1: Downloading original HTML files..." -ForegroundColor Cyan
& .\download_original_html.ps1

Write-Host ""
Write-Host "Step 2: Applying essential fixes only..." -ForegroundColor Cyan
Write-Host "  - Localizing image URLs (images/)" -ForegroundColor White
Write-Host "  - Localizing CSS/JS paths (assets/)" -ForegroundColor White
Write-Host "  - Fixing navigation links" -ForegroundColor White
Write-Host "  - Disabling HTTPS redirects" -ForegroundColor White
Write-Host ""
Write-Host "Ready to apply fixes? Press Enter..." -ForegroundColor Yellow
Read-Host
