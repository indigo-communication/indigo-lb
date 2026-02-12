# Disable all_js.js that might also contain image resizing

Write-Host "Disabling all_js.js..." -ForegroundColor Cyan

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
        
        # Comment out all_js.js
        $content = $content -replace '<script type="text/javascript" src="//www\.indigo-cy\.com/all_js\.js', '<!-- DISABLED: all_js.js may resize images --><script type="text/javascript" src="//www.indigo-cy.com/all_js.js'
        $content = $content -replace '(all_js\.js[^>]+>)', '$1<!-- END DISABLED -->'
        
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "all_js.js disabled!" -ForegroundColor Green
