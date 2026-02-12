# Remove size parameters from image filenames

Write-Host "Removing size parameters from image filenames..." -ForegroundColor Cyan

$images = Get-ChildItem "images/" -Filter "*.jpg"
$renamedCount = 0
$skippedCount = 0

foreach ($img in $images) {
    $oldName = $img.Name
    
    # Check if filename has =sXXX pattern
    if ($oldName -match '=s\d+\.jpg$') {
        # Remove =sXXX pattern
        $newName = $oldName -replace '=s\d+\.jpg$', '.jpg'
        
        # Check if target file already exists
        if (Test-Path "images/$newName") {
            # Target exists, delete the sized version (keep the full resolution)
            Remove-Item "images/$oldName" -Force
            Write-Host "  [DELETED] $oldName (kept full-res)" -ForegroundColor Yellow
            $skippedCount++
        }
        else {
            # Rename to remove size parameter
            Rename-Item "images/$oldName" -NewName $newName
            Write-Host "  [RENAMED] $oldName -> $newName" -ForegroundColor Green
            $renamedCount++
        }
    }
}

Write-Host ""
Write-Host "Complete! Renamed: $renamedCount, Deleted duplicates: $skippedCount" -ForegroundColor Green
Write-Host "Refresh browser (Ctrl+Shift+R) to see images load" -ForegroundColor Cyan
