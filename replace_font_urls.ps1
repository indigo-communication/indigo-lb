# Replace font URLs in HTML files to use local fonts

Write-Host "Replacing font URLs..." -ForegroundColor Cyan

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
        
        # Replace font URLs
        $content = $content -replace "https://storage\.googleapis\.com/xprs_resources/fonts/", "assets/fonts/"
        
        # Save
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed fonts: $file" -ForegroundColor Green
    }
}

Write-Host "Font URLs replaced!" -ForegroundColor Green
