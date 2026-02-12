# Download fresh HTML sources from www.indigo-lb.com
# This restores original files before any modifications

$pages = @(
    @{file="index.html"; url="https://www.indigo-lb.com/"},
    @{file="about-indigo.html"; url="https://www.indigo-lb.com/about-indigo"},
    @{file="animation.html"; url="https://www.indigo-lb.com/animation"},
    @{file="commercials.html"; url="https://www.indigo-lb.com/commercials"},
    @{file="branding.html"; url="https://www.indigo-lb.com/branding"},
    @{file="digital-marketing.html"; url="https://www.indigo-lb.com/digital-marketing"},
    @{file="web-services.html"; url="https://www.indigo-lb.com/web-services"},
    @{file="contact-us.html"; url="https://www.indigo-lb.com/contact-us"}
)

Write-Host "Downloading original HTML files from www.indigo-lb.com..." -ForegroundColor Cyan
Write-Host ""

foreach ($page in $pages) {
    Write-Host "Downloading $($page.file)..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $page.url -OutFile $page.file -UseBasicParsing
        Write-Host "  [OK] $($page.file)" -ForegroundColor Green
    } catch {
        Write-Host "  [ERROR] Failed to download $($page.file): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Download complete!" -ForegroundColor Green
Write-Host "Original HTML files restored from live website" -ForegroundColor Cyan
