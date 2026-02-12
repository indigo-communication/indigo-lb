# Disable xprs_helper.js following itbng's working approach
# itbng successfully runs without xprs_helper.js

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

$totalChanges = 0

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Processing $file..." -ForegroundColor Cyan
        
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Comment out xprs_helper.js (following itbng approach)
        $before = $content
        $content = $content -replace '(\s*)<script src="assets/js/xprs_helper\.js" type="text/javascript"></script>', '$1<!-- DISABLED: xprs_helper.js (not needed, following itbng approach) -->'
        
        if ($content -ne $before) {
            Set-Content $file $content -Encoding UTF8 -NoNewline
            Write-Host "  [OK] Disabled xprs_helper.js" -ForegroundColor Green
            $totalChanges++
        } else {
            Write-Host "  [SKIP] xprs_helper.js already disabled or not found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [ERROR] File not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Changes made to $totalChanges files" -ForegroundColor Green
Write-Host "Configuration now matches itbng (working Indigo CMS site)" -ForegroundColor Cyan
