Write-Host "`n=== DOWNLOADING HIGH-RES IMAGES ===" -ForegroundColor Green

$liveContent = Get-Content "live_about.html" -Raw
$pattern = "https://lh3\\.googleusercontent\\.com/([^`"''\\s=]+)(?:=s\\d+)?"
$matches = [regex]::Matches($liveContent, $pattern)

$urlMap = @{}
foreach ($match in $matches) {
    $fullUrl = $match.Value
    $baseId = $match.Groups[1].Value
    $highResUrl = "https://lh3.googleusercontent.com/$baseId"
    $filename = "$baseId.jpg"
    
    if (-not $urlMap.ContainsKey($filename)) {
        $urlMap[$filename] = $highResUrl
    }
}

Write-Host "Found" $urlMap.Count "unique images to download`n" -ForegroundColor Cyan

$downloaded = 0
$failed = 0
$skipped = 0

foreach ($entry in $urlMap.GetEnumerator()) {
    $filename = $entry.Key
    $url = $entry.Value
    $outputPath = "images/$filename"
    
    if (Test-Path $outputPath) {
        $currentSize = (Get-Item $ $outputPath).Length
        if ($currentSize -gt 100KB) {
            $sizeKB = [math]::Round($currentSize/1KB, 1)
            Write-Host "  Skipped (already high-res):" $filename $sizeKB "KB" -ForegroundColor Gray
            $skipped++
            continue
        }
    }
    
    try {
        Write-Host "  Downloading:" $filename "..." -ForegroundColor Yellow -NoNewline
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
        $newSize = (Get-Item $outputPath).Length
        $newSizeKB = [math]::Round($newSize/1KB, 1)
        Write-Host $newSizeKB "KB" -ForegroundColor Green
        $downloaded++
        Start-Sleep -Milliseconds 500
    }
    catch {
        Write-Host "FAILED" -ForegroundColor Red        Write-Host "    Error:" $_.Exception.Message -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n=== DOWNLOAD COMPLETE ===" -ForegroundColor Green
Write-Host "  Downloaded:" $downloaded "images" -ForegroundColor Green
Write-Host "  Skipped:" $skipped "images" -ForegroundColor Cyan
Write-Host "  Failed:" $failed "images" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

$images = Get-ChildItem "images/*.jpg"
$highRes = @($images | Where-Object { $_.Length -gt 100KB })
$mediumRes = @($images | Where-Object { $_.Length -ge 50KB -and $_.Length -le 100KB })
$lowRes = @($images | Where-Object { $_.Length -lt 50KB })

Write-Host "`n=== NEW IMAGE QUALITY STATS ===" -ForegroundColor Cyan
Write-Host "  High-res (>100KB):" $highRes.Count "images" -ForegroundColor Green
Write-Host "  Medium-res (50-100KB):" $mediumRes.Count "images" -ForegroundColor Yellow
Write-Host "  Low-res (<50KB):" $lowRes.Count "images" -ForegroundColor $(if ($lowRes.Count -gt 20) { "Red" } else { "Green" })

$totalSize = ($images | Measure-Object -Property Length -Sum).Sum
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)
Write-Host "  Total size:" $totalSizeMB "MB" -ForegroundColor Cyan
