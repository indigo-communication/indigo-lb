# Localize Resources Script
# This script replaces all external URLs with local paths

Write-Host "Localizing resources in HTML files..." -ForegroundColor Cyan

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
    Write-Host "`nProcessing $file..." -ForegroundColor Yellow
    
    $content = Get-Content $file -Raw -Encoding UTF8
    
    # 1. Localize Google CDN images (lh3.googleusercontent.com -> images/)
    # Extract the hash after the last / and before = or end of URL
    $content = $content -replace 'https://lh3\.googleusercontent\.com/([^/=\s\)\"'']+)(?:=[^/\s\)\"'']+)?', 'images/$1.jpg'
    
    # 2. Localize CSS files
    $content = $content -replace '//www\.indigo-cy\.com/css/fonts\.css\?v=[^\"'']+', 'assets/css/fonts.css'
    $content = $content -replace '//www\.indigo-cy\.com/css/effects\.css\?v=[^\"'']+', 'assets/css/effects.css'
    $content = $content -replace '//www\.indigo-cy\.com/css/lightbox\.css\?v=[^\"'']+', 'assets/css/lightbox.css'
    
    # 3. Localize JS files
    $content = $content -replace '//www\.indigo-cy\.com/js/lib/jquery-2\.x-git\.min\.js', 'assets/js/jquery-2.x-git.min.js'
    $content = $content -replace '//www\.indigo-cy\.com/js/xprs_helper\.js\?v=[^\"'']+', 'assets/js/xprs_helper.js'
    $content = $content -replace '//www\.indigo-cy\.com/all_js\.js\?v=[^\"'']+', 'assets/js/all_js.js'
    $content = $content -replace '//www\.indigo-cy\.com/js/lib/touchswipe/jquery\.mobile\.custom\.min\.js', 'assets/js/jquery.mobile.custom.min.js'
    $content = $content -replace '//www\.indigo-cy\.com/js/lightbox\.js\?v=[^\"'']+', 'assets/js/lightbox.js'
    $content = $content -replace '//www\.indigo-cy\.com/js/spimeengine\.js\?v=[^\"'']+', 'assets/js/spimeengine.js'
    
    # 4. Remove data-static-server attribute
    $content = $content -replace 'data-static-server="//www\.indigo-cy\.com"', 'data-static-server=""'
    
    # 5. Fix navigation - www.indigo-lb.com to relative paths
    $content = $content -replace 'href="https://www\.indigo-lb\.com/"', 'href="index.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/about-indigo"', 'href="about-indigo.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/animation"', 'href="animation.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/commercials"', 'href="commercials.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/branding"', 'href="branding.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/digital-marketing"', 'href="digital-marketing.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/web-services"', 'href="web-services.html"'
    $content = $content -replace 'href="https://www\.indigo-lb\.com/contact-us"', 'href="contact-us.html"'
    
    # 6. Handle static_style CSS (these are loaded dynamically, keep as comment)
    $content = $content -replace '<link id="([^"]+)-STATIC_STYLE" rel="stylesheet"[^>]+href="//www\.indigo-cy\.com/static_style[^>]+>', '<!-- Static styles are in assets/css/ -->'
    
    # 7. Fix social media icons
    $content = $content -replace '//www\.indigo-cy\.com/images/socialmedia/', 'assets/images/socialmedia/'
    
    # Save the modified content
    $content | Set-Content $file -Encoding UTF8 -NoNewline
    
    Write-Host "  [OK] $file localized" -ForegroundColor Green
}

Write-Host ""
Write-Host "All HTML files localized successfully!" -ForegroundColor Green
Write-Host "Next: Test the site" -ForegroundColor Cyan
