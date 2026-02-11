# Fix image paths - remove size parameters (=s300, =s1600, etc.)

Write-Host "Fixing image paths - removing size parameters..." -ForegroundColor Cyan

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

$fixed = 0

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Remove size parameters from image paths
        # Pattern: images/filename.jpg=s300 -> images/filename.jpg
        # Pattern: images/filename.jpg=s1600 -> images/filename.jpg
        # Pattern: images/filename.jpg=s894 -> images/filename.jpg
        # etc.
        
        $before = $content.Length
        $content = $content -replace '(images/[^"\s\)]+\.jpg)=s\d+', '$1'
        $content = $content -replace '(images/[^"\s\)]+\.jpg)=w\d+-h\d+', '$1'
        $content = $content -replace '(images/[^"\s\)]+\.jpg)=', '$1'
        $after = $content.Length
        
        if ($before -ne $after) {
            $content | Set-Content $file -Encoding UTF8 -NoNewline
            Write-Host "Fixed: $file" -ForegroundColor Green
            $fixed++
        } else {
            Write-Host "No changes: $file" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "Fixed $fixed files" -ForegroundColor Green
Write-Host "Refresh browser to see images!" -ForegroundColor Yellow
