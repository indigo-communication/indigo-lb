# Fix navigation links for local testing
# Convert absolute paths to relative paths with .html extensions

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing Navigation Links" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

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
        
        # Replace navigation links with relative paths
        $content = $content -replace 'href="/"([^"])', 'href="index.html"'
        $content = $content -replace 'href="/">', 'href="index.html">'
        $content = $content -replace 'href="/animation"', 'href="animation.html"'
        $content = $content -replace 'href="/commercials"', 'href="commercials.html"'
        $content = $content -replace 'href="/branding"', 'href="branding.html"'
        $content = $content -replace 'href="/digital-marketing"', 'href="digital-marketing.html"'
        $content = $content -replace 'href="/web-services"', 'href="web-services.html"'
        $content = $content -replace 'href="/about-indigo"', 'href="about-indigo.html"'
        $content = $content -replace 'href="/contact-us"', 'href="contact-us.html"'
        
        # Save with UTF-8 encoding
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed links: $file" -ForegroundColor Green
    } else {
        Write-Host "File not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Navigation Links Fixed!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test: Refresh browser and click Get in Touch" -ForegroundColor Yellow
Write-Host ""
