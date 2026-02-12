# Fix viewport for desktop view

Write-Host "Fixing viewport for desktop layout..." -ForegroundColor Cyan

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

foreach ($file in $htmlFiles) {
    Write-Host "Processing $file..." -ForegroundColor Yellow
    
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # Fix viewport to desktop width
    $content = $content -replace '<meta name="viewport" content="width=device-width, maximum-scale=1"/>', '<meta name="viewport" content="width=1280, initial-scale=1.0"/>'
    
    $content | Set-Content $file -Encoding UTF8 -NoNewline
    
    Write-Host "  [OK] $file" -ForegroundColor Green
}

Write-Host ""
Write-Host "Viewport fixed! Pages will now render in desktop mode." -ForegroundColor Green
Write-Host "Refresh your browser (Ctrl+Shift+R) to see changes" -ForegroundColor Cyan
