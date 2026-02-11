# Fix image paths - convert = to _ to match downloaded filenames

Write-Host "Fixing image paths - converting = to _..." -ForegroundColor Cyan

$htmlFiles = @(
    "index.html",
    "about-indigo.html",
    "contact-us.html",
    "animation.html",
    "commercials.html",
    "branding.html",
    "digital-marketing.html",
    "web-services.html"
)

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Replace = with _ in image paths to match downloaded filenames
        # Pattern: images/filename.jpg=s300 -> images/filename.jpg_s300
        $content = $content -replace 'images/([^"\s\)]+)\.jpg=', 'images/$1.jpg_'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Image paths fixed!" -ForegroundColor Green
Write-Host "Refresh browser (Ctrl+Shift+R) to see images!" -ForegroundColor Yellow
