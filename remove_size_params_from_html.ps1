# Remove =s[0-9]+ size parameters from HTML image URLs
# This allows SpimeEngine to dynamically add correct size parameters

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

$totalReplacements = 0

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Processing $file..." -ForegroundColor Cyan
        
        $content = Get-Content $file -Raw -Encoding UTF8
        $originalLength = $content.Length
        
        # Remove =s followed by digits (handles =s30, =s50, =s200, =s300, =s320, =s894, =s1600, etc.)
        # Pattern 1: In background-image URLs: .jpg=s300) or .jpg=s300);
        $content = $content -replace '(\.jpg)=s\d+(\))', '$1$2'
        
        # Pattern 2: In src and data attributes: .jpg=s50.jpg
        $content = $content -replace '(\.jpg)=s\d+(\.jpg)', '$1'
        
        # Pattern 3: In malformed cases like =s30'.jpg (note the quote before .jpg)
        $content = $content -replace '=s\d+(''\.jpg)', '$1'
        
        $newLength = $content.Length
        $replaced = $originalLength - $newLength
        
        if ($replaced -gt 0) {
            Set-Content $file $content -Encoding UTF8 -NoNewline
            Write-Host "  [OK] Removed $replaced characters from size parameters" -ForegroundColor Green
            $totalReplacements += $replaced
        } else {
            Write-Host "  [SKIP] No size parameters found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [ERROR] File not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Total characters removed: $totalReplacements" -ForegroundColor Green
Write-Host "Done! SpimeEngine will dynamically add size parameters." -ForegroundColor Cyan
