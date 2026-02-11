# Link CSS files to HTML - Test before downloading images

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Linking CSS Files to HTML Pages" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
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
        $content = Get-Content $page.File -Raw -Encoding UTF8
        
        # Extract vbid to match the CSS link pattern
        if ($content -match 'data-root-id="(vbid-[^"]+)"') {
            $vbid = $matches[1]
            
            # Add CSS link in the <head> section
            # Look for </head> tag and insert before it
            if ($content -match '</head>') {
                $cssLink = "`n`t<link rel=`"stylesheet`" href=`"assets/css/$($page.CssName)`" />`n</head>"
                $content = $content -replace '</head>', $cssLink
                
                # Save with UTF-8 encoding
                $content | Set-Content $page.File -Encoding UTF8 -NoNewline
                Write-Host "Linked CSS: $($page.File) -> $($page.CssName)" -ForegroundColor Green
            } else {
                Write-Host "WARNING: Could not find </head> tag in $($page.File)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "WARNING: vbid not found in $($page.File)" -ForegroundColor Red
        }
    } else {
        Write-Host "File not found: $($page.File)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CSS Linking Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next: Start SSL server to test layout" -ForegroundColor Yellow
Write-Host "Run: .\start.ps1" -ForegroundColor White
Write-Host ""
