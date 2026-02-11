# Download images with proper URLs

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Downloading Images" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allImages = Get-Content "image_urls_fixed.txt"
$downloaded = 0
$failed = 0
$skipped = 0

foreach ($url in $allImages) {
    if ([string]::IsNullOrWhiteSpace($url)) { continue }
    
    # Create safe filename from URL
    $urlParts = $url -replace 'https://lh3\.googleusercontent\.com/', '' 
    $safeFilename = $urlParts -replace '[\\/:*?"<>|]', '_'
    
    # Limit filename length
    if ($safeFilename.Length > 150) {
        $safeFilename = $safeFilename.Substring(0, 150)
    }
    
    $filepath = "images\$safeFilename.jpg"
    
    if (Test-Path $filepath) {
        $skipped++
        continue
    }
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $filepath -TimeoutSec 30
        $fileSize = [math]::Round((Get-Item $filepath).Length / 1KB, 2)
        Write-Host "OK: $safeFilename - $fileSize KB" -ForegroundColor Green
        $downloaded++
    } catch {
        Write-Host "FAIL: $safeFilename" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "   Downloaded: $downloaded" -ForegroundColor Green  
Write-Host "   Skipped: $skipped" -ForegroundColor Gray
Write-Host "   Failed: $failed" -ForegroundColor Red
Write-Host ""
