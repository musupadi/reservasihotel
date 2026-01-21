# Fix Windows backslashes in all config.yaml files
$files = Get-ChildItem -Path "organizations" -Recurse -Filter "config.yaml"

foreach ($file in $files) {
    Write-Host "Fixing: $($file.FullName)"
    $content = Get-Content $file.FullName -Raw
    $fixed = $content -replace 'cacerts\\', 'cacerts/'
    Set-Content -Path $file.FullName -Value $fixed -NoNewline
}

Write-Host "`nDone! Fixed $($files.Count) files"
