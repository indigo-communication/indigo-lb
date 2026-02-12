# Fix remaining =s50 in lightbox button images

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
        
        # Fix <img src="images/filename.jpg=s50.jpg" to <img src="images/filename.jpg"
        $content = $content -replace '<img src="images/([^"]+)\.jpg=s\d+\.jpg"', '<img src="images/$1.jpg"'
        
        if ($content -ne $before) {
            Set-Content $file $content -Encoding UTF8 -NoNewline
            Write-Host "  [OK] Fixed lightbox button images" -ForegroundColor Green
            $totalChanges++
        } else {
            Write-Host "  [SKIP] No lightbox image issues found" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Fixed $totalChanges files" -ForegroundColor Green
