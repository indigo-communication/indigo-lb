# Download images properly - keeping original URLs intact

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Downloading Images (Fixed)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Read the image URLs file
if (-not (Test-Path "image_urls.txt")) {
    Write-Host "ERROR: image_urls.txt not found!" -ForegroundColor Red
    exit
}

$allImages = Get-Content "image_urls.txt"
$downloaded = 0
$failed = 0
$skipped = 0

foreach ($url in $allImages) {
    if ([string]::IsNullOrWhiteSpace($url)) { continue }
    
    # Generate filename from URL - use last part of URL path
    $urlParts = $url -split '/'
    $urlHash = $urlParts[-1]
    
    # If URL has = parameters, it's already sized - keep as is
    # If not, we already cleaned it
    
    # Truncate if too long
    if ($urlHash.Length > 100) {
        $urlHash = $urlHash.Substring(0, 100)
    }
    
    $extension = ".jpg"
    
    # Detect extension from URL
    if ($url -match '\.(png|gif|svg|webp)') {
        $extension = ".$($matches[1])"
    }
    
    $filename = "$urlHash$extension"
    $filepath = "images\$filename"
    
    if (Test-Path $filepath) {
        $skipped++
        continue
    }
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $filepath -TimeoutSec 30
        $fileSize = [math]::Round((Get-Item $filepath).Length / 1KB, 2)
        Write-Host "Downloaded: $filename - Size: $fileSize KB" -ForegroundColor Green
        $downloaded++
    } catch {
        Write-Host "Failed: $filename" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Download Summary:" -ForegroundColor Cyan
Write-Host "   Downloaded: $downloaded" -ForegroundColor Green
Write-Host "   Skipped (exist): $skipped" -ForegroundColor Gray
Write-Host "   Failed: $failed" -ForegroundColor Red
Write-Host ""

if ($failed -gt 0) {
    Write-Host "Some images failed - they may be CDN-only or require size parameters" -ForegroundColor Yellow
    Write-Host "The site should still work with available images" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next: Replace image URLs in HTML files" -ForegroundColor Yellow
Write-Host ""
