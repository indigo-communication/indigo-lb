# Fix external server references that cause page to hang

Write-Host "Fixing external server references..." -ForegroundColor Cyan

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
        
        # Remove/disable external server references
        $content = $content -replace 'data-static-server="//www\.indigo-cy\.com"', 'data-static-server=""'
        $content = $content -replace 'data-imos-server="https://imos[^"]*"', 'data-imos-server=""'
        
        # Comment out YouTube API if causing issues
        $content = $content -replace '<script src="https://www\.youtube\.com/iframe_api"></script>', '<!-- <script src="https://www.youtube.com/iframe_api"></script> -->'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host "External references removed!" -ForegroundColor Green
