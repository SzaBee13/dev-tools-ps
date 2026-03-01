# Open command implementation

function Invoke-DevOpen {
    param(
        [string]$typeOrName,
        [object]$code,
        [object]$explorer,
        [string]$DriveRoot
    )
    
    # Load default config
    $config = Get-DevConfig
    $openCode = $config.code
    $openExplorer = $config.explorer

    # Override with command-line booleans if passed
    if ($PSBoundParameters.ContainsKey("code")) { $openCode = $code }
    if ($PSBoundParameters.ContainsKey("explorer")) { $openExplorer = $explorer }

    # Split folder/subpath
    $parts = $typeOrName -split "/"
    $searchName = $parts[0]
    $subPath = if ($parts.Length -gt 1) { ($parts[1..($parts.Length - 1)] -join "\") } else { "" }

    # Search folder
    $foundFolder = Search-Folder -rootPath $DriveRoot -folderName $searchName

    if ($foundFolder) {
        $targetPath = if ($subPath) { Join-Path $foundFolder.FullName $subPath } else { $foundFolder.FullName }
        if (Test-Path $targetPath) {
            Set-Location $targetPath
            if ($openCode) { code . }
            if ($openExplorer) { explorer.exe . }
        }
        else {
            Write-Host "Subfolder '$subPath' not found in '$($foundFolder.FullName)'" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Folder '$searchName' not found in $DriveRoot" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Invoke-DevOpen
