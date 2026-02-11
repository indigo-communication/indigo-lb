# Disable HTTPS redirects for local testing

Write-Host "Disabling HTTPS redirects..." -ForegroundColor Cyan

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
        
        # Find and comment out HTTPS redirect lines
        $pattern = "if\(window\.location\.protocol != 'https:'\)"
        
        if ($content -match $pattern) {
            $content = $content -replace "if\(window\.location\.protocol != 'https:'\)", "// DISABLED FOR LOCAL: if(window.location.protocol != 'https:')"
            $content = $content -replace "window\.location\.href = 'https:'", "// DISABLED FOR LOCAL: window.location.href = 'https:'"
            
            $content | Set-Content $file -Encoding UTF8 -NoNewline
            Write-Host "Disabled HTTPS redirect: $file" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "HTTPS redirects disabled!" -ForegroundColor Green
Write-Host "Note: Re-enable for production deployment!" -ForegroundColor Yellow
