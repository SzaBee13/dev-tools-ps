# Git-related commands implementation

function Invoke-DevPull {
    param(
        [string]$typeOrName,
        [string]$name,
        [string]$DriveRoot
    )
    
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

function Invoke-DevRelease {
    param(
        [string]$typeOrName,
        [string]$name
    )
    
    git add .
    if ($name) { git commit -m $typeOrName -m $name } else { git commit -m $typeOrName }
    git push
}

function Invoke-DevLocalRelease {
    param(
        [string]$typeOrName,
        [string]$name
    )
    
    git add .
    if ($name) { git commit -m $typeOrName -m $name } else { git commit -m $typeOrName }
}

function Invoke-DevStatus {
    git status
}

function Invoke-DevInit {
    param(
        [string]$typeOrName,
        [string]$name
    )
    
    git init
    git branch -M main

    # Load licenses
    $licenses = Get-DevLicenses

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

function Test-GitRemote {
  param(
    [string]$Folder = (Get-Location)
  )

  if (-not (Test-Path (Join-Path $Folder ".git"))) { return $false }

  $remoteOrigin = git -C $Folder remote get-url origin 2>$null
  if (-not $remoteOrigin) { return $false }

  return $true
}