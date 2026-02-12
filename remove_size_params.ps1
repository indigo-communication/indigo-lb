# Fix image paths - remove ALL size parameters completely

Write-Host "Removing size parameters from image paths..." -ForegroundColor Cyan

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
        
        # Remove ALL size parameters from image paths:
        # images/abc.jpg=s300 -> images/abc.jpg
        # images/abc.jpg_s300 -> images/abc.jpg
        # images/abc.jpg=s1600 -> images/abc.jpg
        # etc.
        
        $content = $content -replace '(images/[^"\s\)]+\.jpg)[_=]s\d+', '$1'
        $content = $content -replace '(images/[^"\s\)]+\.jpg)[_=]w\d+-h\d+', '$1'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "All size parameters removed!" -ForegroundColor Green
Write-Host "Images now point to full-size versions only" -ForegroundColor Yellow
