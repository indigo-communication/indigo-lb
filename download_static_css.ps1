# Download static CSS from live site

Write-Host "Downloading static CSS from live site..." -ForegroundColor Cyan

$downloads = @(
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-7347e24d-lok1anrm&caller=live"; file="assets/css/static_style_about.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-d9dd7b3e-lok1anrm&caller=live"; file="assets/css/static_style_contact.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-e24a6aa6-lok1anrm&caller=live"; file="assets/css/static_style_animation.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-129af43c-lok1anrm&caller=live"; file="assets/css/static_style_commercials.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-9bb631c0-aoule9dx&caller=live"; file="assets/css/static_style_branding.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-45c49192-hazr7sim&caller=live"; file="assets/css/static_style_digital.css"},
    @{url="https://www.indigo-cy.com/static_style?v=1.6.0f2-noimos&vbid=vbid-f461a13d-hazr7sim&caller=live"; file="assets/css/static_style_webservices.css"}
)

foreach ($item in $downloads) {
    Write-Host "  Downloading $($item.file)..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri $item.url -OutFile $item.file -UseBasicParsing
        $size = (Get-Item $item.file).Length
        Write-Host "  [OK] $($item.file) ($size bytes)" -ForegroundColor Green
    }
    catch {
        Write-Host "  [FAILED] $($item.file)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Complete! Refresh browser (Ctrl+Shift+R)" -ForegroundColor Green
