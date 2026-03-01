# Remove command implementation

function Invoke-DevRemove {
    param(
        [string]$typeOrName,
        [string]$DriveRoot
    )
    
    $searchName = $typeOrName
    $foundFolder = Search-Folder -rootPath $DriveRoot -folderName $searchName

    if ($foundFolder) {
        Remove-Item -Path $foundFolder.FullName -Recurse -Force
        Write-Host "Folder '$searchName' has been removed from $DriveRoot" -ForegroundColor Green
    }
    else {
        Write-Host "Folder '$searchName' not found in $DriveRoot" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Invoke-DevRemove
