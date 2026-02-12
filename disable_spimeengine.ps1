# Disable external JavaScript that adds image size parameters

Write-Host "Disabling external JS that modifies image URLs..." -ForegroundColor Cyan

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
        
        # Comment out spimeengine.js and xprs_helper.js that modify image URLs
        $content = $content -replace '<script src="//www\.indigo-cy\.com/js/xprs_helper\.js', '<!-- DISABLED FOR LOCAL --><script src="//www.indigo-cy.com/js/xprs_helper.js'
        $content = $content -replace '<script src="//www\.indigo-cy\.com/js/spimeengine\.js', '<!-- DISABLED FOR LOCAL --><script src="//www.indigo-cy.com/js/spimeengine.js'
        $content = $content -replace '(spimeengine\.js[^>]+>)', '$1<!-- END DISABLED -->'
        $content = $content -replace '(xprs_helper\.js[^>]+>)', '$1<!-- END DISABLED -->'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "External JS disabled!" -ForegroundColor Green
Write-Host "Images will no longer have size parameters added dynamically" -ForegroundColor Yellow
