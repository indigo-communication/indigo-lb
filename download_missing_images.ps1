# Download missing images

Write-Host "Downloading missing images..." -ForegroundColor Cyan

$missingImages = @(
    @{hash="Noh7kIm5kfqbPDsQ7iI6rTN4euBfQ7VMAlvb1SR-86_5iQtOVXQ3_UURL-N-97M-RWfKGNH6zjcbX9dCQW8"; size="s30"},
    @{hash="2M3h4CZBMs93o0xtkzkIWJqLF3D042oh1uQZyF0VYQlmGWdEDh9Y6hC7cBZ712umyXcTAHz_nrGGA--_"; size="s30"}
)

foreach ($img in $missingImages) {
    $hash = $img.hash
    $size = $img.size
    $filename = "$hash.jpg"
    $url = "https://lh3.googleusercontent.com/$hash=$size"
    
    if (-not (Test-Path "images/$filename")) {
        try {
            Write-Host "  Downloading $filename..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $url -OutFile "images/$filename" -UseBasicParsing
            Write-Host "  [OK] $filename" -ForegroundColor Green
        }
        catch {
            Write-Host "  [FAILED] $filename - $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "  [SKIP] $filename already exists" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Complete!" -ForegroundColor Green
