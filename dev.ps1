function dev {
    param(
        [Parameter(Mandatory = $true)]
        [string]$action,

        [string]$typeOrName,

        [string]$name,

        [bool]$code,

        [bool]$explorer
    )

    $DriveRoot = "D:\"
    $Help = @"
Usage:
dev open <folder-name>               - Open a folder in VSCode and Explorer
dev create <vite|web|python|home|discord|alpha-cpp|alpha-web|alpha-vite> <project-name> - Create a new project
dev rm <folder-name>                 - Remove a folder
dev pull [<git-repo-url>] [folder-name] - Clone or pull a git repository into a specified or default folder
dev release <commit-message> [detailed-message] - Commit and push changes to the remote repository
dev local-release <commit-message> [detailed-message] - Commit changes locally without pushing
dev init [<git-repo-url>]            - Initialize a new git repository, optionally linking to a remote
dev status                           - Show git status
dev ls <web|python|home|discord|alpha-cpp|alpha-web> - List folders in specified category

dev set --code=true/false            - Open or not code by default (saves to %appdata%/SzaBee13/dev/config.json)
dev set --explorer=true/false        - Open or not explorer by default (saves to %appdata%/SzaBee13/dev/config.json)
"@

    # Change these edit add remove
    $roots = @{
        web         = "D:\!_WEB"
        python      = "D:\_python"
        home        = "D:\_home"
        discord     = "D:\_discord"
        "alpha-cpp" = "D:\_alpha\cpp"
        "alpha-web" = "D:\_alpha\web"
    }

    function Search-Folder {
        param (
            [string]$rootPath,
            [string]$folderName
        )
        return Get-ChildItem -Path $rootPath -Directory -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -eq $folderName } |
        Select-Object -First 1
    }

    switch ($action) {
        "open" {
            # Load default config
            $ConfigFile = Join-Path $env:APPDATA "SzaBee13\dev\config.json"
            $openCode = $true
            $openExplorer = $true
            if (Test-Path $ConfigFile) {
                $cfg = Get-Content $ConfigFile | ConvertFrom-Json
                $openCode = $cfg.code
                $openExplorer = $cfg.explorer
            }

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
        "rm" {
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
        "ls" {
            if ($roots.ContainsKey($typeOrName)) {
                Get-ChildItem -Path $roots[$typeOrName] -Directory | Select-Object Name
            }
            else {
                Write-Host "Please specify a valid type: web, python, home, discord, alpha-cpp, alpha-web" -ForegroundColor Red
            }
        }
        "create" {
            if (-not $roots.ContainsKey($typeOrName) -and $typeOrName -ne "vite" -and $typeOrName -ne "alpha-vite") {
                Write-Host $Help -ForegroundColor Yellow
                return
            }

            $rootPath = $roots[$typeOrName] 
            if ($typeOrName -eq "vite" -or $typeOrName -eq "alpha-vite") {
                $rootPath = if ($typeOrName -eq "vite") { $roots["web"] } else { $roots["alpha-web"] }
                Set-Location $rootPath
                npm create vite@latest $name
                Set-Location "$rootPath\$name"
                npm install
            }
            else {
                Set-Location $rootPath
                New-Item -Name $name -ItemType Directory | Out-Null
                Set-Location "$rootPath\$name"
            }

            code .
            explorer.exe .
        }
        "pull" {
            if (Test-Path ".git") {
                git pull
                return
            }
            elseif (-not $typeOrName) {
                Write-Host "Please provide a git repository URL to clone." -ForegroundColor Red
                return
            }

            if (-not $name) { $name = "!_PULLED" }
            $clonePath = Join-Path $DriveRoot $name
            if (-not (Test-Path $clonePath)) { New-Item -Path $clonePath -ItemType Directory | Out-Null }

            Set-Location $clonePath
            git clone $typeOrName
            $repoFolder = Join-Path $clonePath ($typeOrName.Split('/')[-1] -replace '\.git$', '')
            if (Test-Path $repoFolder) {
                Set-Location $repoFolder
                code .
                explorer.exe .
            }
        }
        "release" {
            git add .
            if ($name) { git commit -m $typeOrName -m $name } else { git commit -m $typeOrName }
            git push
        }
        "local-release" {
            git add .
            if ($name) { git commit -m $typeOrName -m $name } else { git commit -m $typeOrName }
        }
        "status" { git status }
        "init" {
            git init
            git branch -M main

            # Path to local licenses JSON
            $LicensesPath = Join-Path $env:APPDATA "SzaBee13\dev\licenses.json"

            # Load licenses JSON, download if not found
            if (Test-Path $LicensesPath) {
                $licenses = Get-Content $LicensesPath | ConvertFrom-Json
            }
            else {
                Write-Host "No local licenses found. Downloading from GitHub..." -ForegroundColor Yellow
                $url = "https://raw.githubusercontent.com/SzaBee13/dev-tools-ps/refs/heads/main/licenses.json"

                try {
                    $licensesJson = Invoke-RestMethod -Uri $url
                    # Save it locally for future use
                    $licensesJson | ConvertTo-Json -Compress | Set-Content -Path $LicensesPath
                    $licenses = $licensesJson
                    Write-Host "Licenses downloaded and saved to $LicensesPath" -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed to download licenses JSON. Proceeding without it." -ForegroundColor Red
                    $licenses = @{}
                }
            }

            # Add license file if user specified
            if ($name -and $licenses.ContainsKey($name.ToLower())) {
                $licenseText = $licenses[$name.ToLower()]

                # Replace [yyyy] with current year
                $currentYear = (Get-Date).Year
                $licenseText = $licenseText -replace "\[yyyy\]", $currentYear

                Set-Content -Path "LICENSE" -Value $licenseText
                Write-Host "License '$name' added to project." -ForegroundColor Green
            }

            # Git remote and initial commit
            if ($typeOrName) {
                git remote add origin $typeOrName
                git add .
                git commit -m "Initial commit"
                git push -u origin main
            }
            else {
                git add .
                git commit -m "Initial commit"
            }
        }

        "set" {
            $ConfigPath = Join-Path $env:APPDATA "SzaBee13\dev"
            $ConfigFile = Join-Path $ConfigPath "config.json"

            if (-not (Test-Path $ConfigPath)) {
                New-Item -Path $ConfigPath -ItemType Directory -Force | Out-Null
            }

            # Load existing config or create default
            if (Test-Path $ConfigFile) {
                $config = Get-Content $ConfigFile | ConvertFrom-Json
            }
            else {
                $config = [PSCustomObject]@{
                    code     = $true
                    explorer = $true
                }
            }

            if ($typeOrName -match "--code=(true|false)") {
                $config.code = [bool]::Parse($Matches[1])
                Write-Host "Set 'code' to $($config.code)" -ForegroundColor Green
            }
            elseif ($typeOrName -match "--explorer=(true|false)") {
                $config.explorer = [bool]::Parse($Matches[1])
                Write-Host "Set 'explorer' to $($config.explorer)" -ForegroundColor Green
            }
            else {
                Write-Host "Please use --code=true/false or --explorer=true/false" -ForegroundColor Yellow
                return
            }

            # Save back to JSON
            $config | ConvertTo-Json | Set-Content $ConfigFile
        }

        "help" { Write-Host $Help -ForegroundColor Yellow }
        "?" { Write-Host $Help -ForegroundColor Yellow }
        default { Write-Host $Help -ForegroundColor Yellow }
    }
}
