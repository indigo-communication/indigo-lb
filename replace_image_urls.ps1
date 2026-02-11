# Replace image URLs in HTML files

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Replacing Image URLs in HTML" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

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
        
        # Replace all googleusercontent image URLs with local paths
        # Pattern: https://lh3.googleusercontent.com/ABC123...
        # We need to convert the URL to the safe filename format we used
        
        $matches = [regex]::Matches($content, '(https://lh3\.googleusercontent\.com/[^\s\)\"\<]+)')
        
        Write-Host "Processing: $file - Found $($matches.Count) image URLs" -ForegroundColor Cyan
        
        foreach ($match in $matches) {
            $originalUrl = $match.Value
            
            # Create the same safe filename we used when downloading
            $urlPart = $originalUrl -replace 'https://lh3\.googleusercontent\.com/', ''
            $safeFilename = $urlPart -replace '[\\/:*?"<>|]', '_'
            
            # Limit filename length to match download script
            if ($safeFilename.Length > 150) {
                $safeFilename = $safeFilename.Substring(0, 150)
            }
            
            $localPath = "images/$safeFilename.jpg"
            
            # Replace in content
            $content = $content.Replace($originalUrl, $localPath)
        }
        
        # Save with UTF-8 encoding
        $content | Set-Content $file -Encoding UTF8 -NoNewline
        Write-Host "   Saved: $file" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Image URL Replacement Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Refresh browser to see images!" -ForegroundColor Yellow
Write-Host ""
