# Test: Compare live site vs local

Write-Host "Opening live site and local site side by side..." -ForegroundColor Cyan
Write-Host ""
Write-Host "LIVE SITE:" -ForegroundColor Yellow
Start-Process "https://www.indigo-lb.com/about-indigo"
Start-Sleep -Seconds 2
Write-Host ""
Write-Host "LOCAL SITE:" -ForegroundColor Yellow  
Start-Process "https://127.0.0.1:9000/about-indigo.html"
Write-Host ""
Write-Host "Compare them side by side and tell me EXACTLY what's different:" -ForegroundColor Green
Write-Host "  1. Image sizes?" -ForegroundColor White
Write-Host "  2. Text layout?" -ForegroundColor White
Write-Host "  3. Spacing/margins?" -ForegroundColor White
Write-Host "  4. Element positions?" -ForegroundColor White
