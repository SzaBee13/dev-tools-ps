# Helper functions for dev utility

function Search-Folder {
    param (
        [string]$rootPath,
        [string]$folderName
    )
    return Get-ChildItem -Path $rootPath -Directory -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq $folderName } |
    Select-Object -First 1
}

function ConvertTo-Hashtable($object) {
    if ($null -eq $object) { return @{} }
    if ($object -is [hashtable]) { return $object }
    $hash = @{}
    $object.PSObject.Properties | ForEach-Object {
        $hash[$_.Name] = if ($_.Value -is [psobject]) {
            ConvertTo-Hashtable $_.Value
        }
        else {
            $_.Value
        }
    }
    return $hash
}
