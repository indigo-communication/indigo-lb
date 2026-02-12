# Fix remaining issues: HTTPS redirects, fonts, and static CSS

Write-Host "Fixing remaining issues..." -ForegroundColor Cyan

# Map HTML files to their static CSS files
$staticCssMap = @{
    "index.html" = "static_style_index.css"
    "about-indigo.html" = "static_style_about.css"
    "animation.html" = "static_style_animation.css"
    "commercials.html" = "static_style_commercials.css"
    "branding.html" = "static_style_branding.css"
    "digital-marketing.html" = "static_style_digital.css"
    "web-services.html" = "static_style_webservices.css"
    "contact-us.html" = "static_style_contact.css"
}

foreach ($file in $staticCssMap.Keys) {
    Write-Host "`nProcessing $file..." -ForegroundColor Yellow
    
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # 1. Disable HTTPS redirect (comment it out)
    $content = $content -replace "if\(window\.location\.protocol != 'https:'\)\s*\r?\n\s*\{\s*location\.href\s*=\s*location\.href\.replace\(`"http://`", `"https://`"\);\s*\}", "/* HTTPS redirect disabled for local development */`r`n/* if(window.location.protocol != 'https:') { location.href = location.href.replace('http://', 'https://'); } */"
    
    # 2. Localize Google Storage fonts
    $content = $content -replace "https://storage\.googleapis\.com/xprs_resources/fonts/", "assets/fonts/"
    
    # 3. Add static CSS link (replace the comment placeholder)
    $staticCss = $staticCssMap[$file]
    $content = $content -replace "<!-- Static styles are in assets/css/ -->", "<link rel=`"stylesheet`" type=`"text/css`" href=`"assets/css/$staticCss`" />"
    
    # Save
    $content | Set-Content $file -Encoding UTF8 -NoNewline
    
    Write-Host "  [OK] $file fixed" -ForegroundColor Green
}

Write-Host ""
Write-Host "All issues fixed!" -ForegroundColor Green
Write-Host "Testing server at https://127.0.0.1:9000" -ForegroundColor Cyan
