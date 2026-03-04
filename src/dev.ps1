# Dev PowerShell Utility - Main Entry Point
# Modular version with separate command files

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Import core modules
. "$ScriptDir\core\Helpers.ps1"
. "$ScriptDir\core\Config.ps1"

# Import command modules
. "$ScriptDir\commands\Git.ps1"
. "$ScriptDir\commands\Open.ps1"
. "$ScriptDir\commands\Create.ps1"
. "$ScriptDir\commands\Remove.ps1"
. "$ScriptDir\commands\List.ps1"
. "$ScriptDir\commands\Set.ps1"

function dev {
    param(
        [Parameter(Mandatory = $true)]
        [string]$action,

        [string]$typeOrName,

        [string]$name,

        [object]$code,
        [object]$explorer,
        
        [switch]$json
    )

    $config = Get-DevConfig
    $roots = Get-DevRoots
    $DriveRoot = $config.driveRoot
    if (-not $DriveRoot) {
        if ($roots.Count -gt 0) {
            $DriveRoot = $roots.Values | Select-Object -First 1
        }
        else {
            $DriveRoot = "C:\dev"
        }
    }
$rootsList = if ($roots.Count -gt 0) { ($roots.Keys | Sort-Object) -join '|' } else { '!! YOU HAVE NO ROOTS !!' }
    $Help = @"
Usage:
dev open <folder-name>               - Open a folder in VSCode and Explorer
dev create <$rootsList> <project-name> - Create a new project
dev rm <folder-name>                 - Remove a folder
dev pull [<git-repo-url>] [folder-name] - Clone or pull a git repository into a specified or default folder
dev release <commit-message> [detailed-message] - Commit and push changes to the remote repository
dev local-release <commit-message> [detailed-message] - Commit changes locally without pushing
dev init [<git-repo-url>]            - Initialize a new git repository, optionally linking to a remote
dev status                           - Show git status
dev list [--json]                    - List folders or repositories (--json outputs repos as JSON)
dev ls <root-name>                   - List folders in specified category
dev repos:scan                       - Scan all folders for git repos and save to repos.json

dev set --code=true/false            - Open or not code by default (saves to %appdata%/SzaBee13/dev/config.json)
dev set --explorer=true/false        - Open or not explorer by default (saves to %appdata%/SzaBee13/dev/config.json)
dev set root <root-name> <path|rm|remove> - Add root to roots (saves to %appdata%/SzaBee13/dev/roots.json) if path is rm or remove it'll remove that root from roots.json
"@

    # Load roots configuration
    $roots = Get-DevRoots

    # Dispatch to appropriate command
    switch ($action) {
        "open" {
            Invoke-DevOpen -typeOrName $typeOrName -code $code -explorer $explorer -DriveRoot $DriveRoot
        }
        "rm" {
            Invoke-DevRemove -typeOrName $typeOrName -DriveRoot $DriveRoot
        }
        "ls" {
            Invoke-DevList -typeOrName $typeOrName -roots $roots
        }
        "list" {
            if ($typeOrName -eq "--json" -or $json) {
                Invoke-DevList -typeOrName $typeOrName -json -roots $roots
            }
            else {
                Invoke-DevList -typeOrName $typeOrName -roots $roots
            }
        }
        "repos:scan" {
            Invoke-ReposScan -roots $roots
        }
        "create" {
            Invoke-DevCreate -typeOrName $typeOrName -name $name -roots $roots
        }
        "pull" {
            Invoke-DevPull -typeOrName $typeOrName -name $name -DriveRoot $DriveRoot
        }
        "release" {
            Invoke-DevRelease -typeOrName $typeOrName -name $name
        }
        "local-release" {
            Invoke-DevLocalRelease -typeOrName $typeOrName -name $name
        }
        "status" {
            Invoke-DevStatus
        }
        "init" {
            Invoke-DevInit -typeOrName $typeOrName -name $name
        }
        "set" {
            Invoke-DevSet -typeOrName $typeOrName -name $name -code $code
        }
        "help" { Write-Host $Help -ForegroundColor Yellow }
        "?" { Write-Host $Help -ForegroundColor Yellow }
        default { Write-Host $Help -ForegroundColor Yellow }
    }
}
