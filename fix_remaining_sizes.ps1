# Fix remaining lightbox =s50 issues (corrected pattern)

$htmlFiles = @(
    "index.html",
    "about-indigo.html", 
    "animation.html",
    "commercials.html",
    "branding.html",
    "digital-marketing.html",
    "web-services.html",
    "contact-us.html"
)

$totalChanges = 0

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Processing $file..." -ForegroundColor Cyan
        
        $content = Get-Content $file -Raw -Encoding UTF8
        $before = $content
        
        # Fix images/*.jpg=s50.jpg to images/*.jpg
        $content = $content -replace '=s\d+\.jpg', '.jpg'
        
        if ($content -ne $before) {
            Set-Content $file $content -Encoding UTF8 -NoNewline
            Write-Host "  [OK] Fixed remaining size parameters" -ForegroundColor Green
            $totalChanges++
        } else {
            Write-Host "  [SKIP] Already clean" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Fixed $totalChanges files" -ForegroundColor Green
