# Extract image URLs properly - keep size parameters intact

Write-Host "Extracting image URLs properly..." -ForegroundColor Cyan

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

$allImages = @()

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        # Extract ALL googleusercontent URLs - keep size parameters!
        $urls = [regex]::Matches($content, 'https://lh3\.googleusercontent\.com/[^\s\)\"\<]+') | 
            ForEach-Object { $_.Value }
        
        foreach ($url in $urls) {
            $allImages += $url
        }
    }
}

$allImages = $allImages | Select-Object -Unique | Sort-Object
Write-Host "Found $($allImages.Count) unique image URLs" -ForegroundColor Green

# Save to file
$allImages | Out-File "image_urls_fixed.txt" -Encoding UTF8
Write-Host "Saved to: image_urls_fixed.txt" -ForegroundColor Green
