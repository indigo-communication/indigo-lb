# Properly disable HTTPS redirects - fix the redirect code block

Write-Host "Fixing HTTPS redirect blocks..." -ForegroundColor Cyan

$htmlFiles = @(
    "index.html",
    "about-indigo.html",
    "animation.html",
    "commercials.html",
    "branding.html",
    "digital-marketing.html",
    "web-services.html"
)

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Find and properly comment out the entire HTTPS redirect block
        # Pattern: if(window.location.protocol != 'https:') 
        #          { location.href = location.href.replace("http://", "https://"); }
        
        # Replace the redirect block
        $pattern = '(<script[^>]*>\s*)(// DISABLED FOR LOCAL: )?if\(window\.location\.protocol != [\''"]https:[\''"][^\)]*\)\s*\{\s*location\.href\s*=\s*location\.href\.replace\([^\)]+\);\s*\}'
        $replacement = '$1// DISABLED FOR LOCAL: HTTPS redirect' + "`n" + '// if(window.location.protocol != ''https:'') ' + "`n" + '// { location.href = location.href.replace("http://", "https://"); }'
        
        $content = $content -replace $pattern, $replacement
        
        # Save
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "Fixed: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "All HTTPS redirects properly disabled!" -ForegroundColor Green
Write-Host "Refresh browser to test contact page" -ForegroundColor Yellow
