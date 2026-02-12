# Localize deferred CSS files

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
        $before = $content
        
        # Localize effects.css
        $content = $content -replace '//www\.indigo-cy\.com/css/effects\.css\?v=[^"]+', 'assets/css/effects.css'
        
        # Localize lightbox.css
        $content = $content -replace '//www\.indigo-cy\.com/css/lightbox\.css\?v=[^"]+', 'assets/css/lightbox.css'
        
        if ($content -ne $before) {
            Set-Content $file $content -Encoding UTF8 -NoNewline
            Write-Host "  [OK] Localized deferred CSS" -ForegroundColor Green
            $totalChanges++
        } else {
            Write-Host "  [SKIP] Already localized" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "Localized CSS in $totalChanges files" -ForegroundColor Green
