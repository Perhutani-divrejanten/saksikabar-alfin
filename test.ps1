Write-Host 'Test'
$content = Get-Content 'index.html' -Encoding UTF8 -Raw
Write-Host $content.SubString(0,100)
$content -replace 'Janten Bersuara', 'Janten Bersuara'
