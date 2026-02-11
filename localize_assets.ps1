# Indigo LB - Asset Localization Script
# Handles vbid CSS, images, fonts, and JS for Indigo CMS platform

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Indigo LB - Asset Localization Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create directory structure
$directories = @(
    "assets\css",
    "assets\js",
    "assets\fonts",
    "images"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "Created: $dir" -ForegroundColor Green
    }
}

Write-Host ""

# Step 1: Extract vbid from each HTML file and download page-specific CSS
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STAGE 1: Extracting vbid and Downloading Page-Specific CSS" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$htmlFiles = @(
    @{File="index.html"; CssName="static_style_index.css"},
    @{File="about-indigo.html"; CssName="static_style_about.css"},
    @{File="contact.html"; CssName="static_style_contact.css"},
    @{File="animation.html"; CssName="static_style_animation.css"},
    @{File="commercials.html"; CssName="static_style_commercials.css"},
    @{File="branding.html"; CssName="static_style_branding.css"},
    @{File="digital-marketing.html"; CssName="static_style_digital.css"},
    @{File="web-services.html"; CssName="static_style_webservices.css"}
)

foreach ($page in $htmlFiles) {
    if (Test-Path $page.File) {
        $content = Get-Content $page.File -Raw
        if ($content -match 'data-root-id="(vbid-[^"]+)"') {
            $vbid = $matches[1]
            $cssFileName = $page.CssName
            Write-Host "File: $($page.File) - vbid: $vbid" -ForegroundColor Cyan
            
            # Download page-specific CSS
            $cssUrl = "https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos-no-viewer&vbid=$vbid&caller=live"
            $cssPath = "assets\css\$cssFileName"
            
            try {
                Invoke-WebRequest -Uri $cssUrl -OutFile $cssPath
                $fileSize = [math]::Round((Get-Item $cssPath).Length / 1KB, 2)
                Write-Host "   Downloaded: $cssFileName - Size: $fileSize KB" -ForegroundColor Green
            } catch {
                Write-Host "   Failed to download CSS for $($page.File)" -ForegroundColor Red
            }
        } else {
            Write-Host "WARNING: $($page.File) - vbid not found!" -ForegroundColor Red
        }
    } else {
        Write-Host "WARNING: $($page.File) not found - skipping" -ForegroundColor Yellow
    }
}

Write-Host ""

# Step 2: Extract all image URLs
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STAGE 2: Extracting Image URLs" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$allImages = @()
foreach ($page in $htmlFiles) {
    if (Test-Path $page.File) {
        $content = Get-Content $page.File -Raw
        
        # Extract lh3.googleusercontent.com images
        $googleImages = [regex]::Matches($content, 'https://lh3\.googleusercontent\.com/[^\"\\s\)]+') | 
            ForEach-Object { $_.Value } | Select-Object -Unique
        
        foreach ($url in $googleImages) {
            # Remove size parameters to get high-quality images
            $cleanUrl = $url -replace '=s\d+$', ''
            $cleanUrl = $cleanUrl -replace '=w\d+-h\d+', ''
            $allImages += $cleanUrl
        }
    }
}

$allImages = $allImages | Select-Object -Unique
Write-Host "Found $($allImages.Count) unique images" -ForegroundColor Cyan

# Save image URLs to file
$allImages | Out-File "image_urls.txt" -Encoding UTF8
Write-Host "Image URLs saved to image_urls.txt" -ForegroundColor Green
Write-Host ""

# Step 3: Download images
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STAGE 3: Downloading Images - High Quality" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$downloaded = 0
$failed = 0

foreach ($url in $allImages) {
    # Generate simple filename from URL - use last part of URL path
    $urlParts = $url -split '/'
    $urlHash = $urlParts[-1]
    
    # If URL ID is too long, truncate it
    if ($urlHash.Length > 50) {
        $urlHash = $urlHash.Substring(0, 50)
    }
    
    $extension = ".jpg"
    
    # Detect extension from URL
    if ($url -match '\.(png|gif|svg|webp)') {
        $extension = ".$($matches[1])"
    }
    
    $filename = "$urlHash$extension"
    $filepath = "images\$filename"
    
    if (Test-Path $filepath) {
        Write-Host "Skipped - exists: $filename" -ForegroundColor Gray
        continue
    }
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $filepath -TimeoutSec 30
        $fileSize = [math]::Round((Get-Item $filepath).Length / 1KB, 2)
        Write-Host "Downloaded: $filename - Size: $fileSize KB" -ForegroundColor Green
        $downloaded++
    } catch {
        Write-Host "Failed: $filename - $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Download Summary:" -ForegroundColor Cyan
Write-Host "   Downloaded: $downloaded" -ForegroundColor Green
Write-Host "   Failed: $failed" -ForegroundColor Red
Write-Host ""

# Step 4: Download fonts
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STAGE 4: Downloading Fonts" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$fontUrls = @(
    "https://storage.googleapis.com/xprs_resources/fonts/helveticaneuethn-webfont.eot",
    "https://storage.googleapis.com/xprs_resources/fonts/helveticaneuethn-webfont.woff",
    "https://storage.googleapis.com/xprs_resources/fonts/helveticaneuethn-webfont.ttf",
    "https://storage.googleapis.com/xprs_resources/fonts/helveticaneuethn-webfont.svg"
)

foreach ($fontUrl in $fontUrls) {
    $fontName = Split-Path $fontUrl -Leaf
    $fontPath = "assets\fonts\$fontName"
    
    if (Test-Path $fontPath) {
        Write-Host "Font exists: $fontName" -ForegroundColor Gray
        continue
    }
    
    try {
        Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath
        $fileSize = [math]::Round((Get-Item $fontPath).Length / 1KB, 2)
        Write-Host "Downloaded: $fontName - Size: $fileSize KB" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download: $fontName" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Asset Localization Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Run replace_paths.ps1 to update HTML files with local paths" -ForegroundColor White
Write-Host "2. Test locally with start.ps1" -ForegroundColor White
Write-Host "3. Fix navigation links and disable HTTPS redirects" -ForegroundColor White
Write-Host ""
