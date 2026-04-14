# Rebrand Script for Janten Bersuara
# Backup articles.json
Copy-Item -Path "articles.json" -Destination "articles.json.bak.$(Get-Date -Format 'yyyyMMddHHmmss')" -Force

# Initialize counters
$filesChanged = @{
    mainPages = 0
    articlePages = 0
    css = 0
    package = 0
    docs = 0
}

# Function to perform replacements in a file
function Replace-InFile {
    param (
        [string]$filePath,
        [array]$replacements
    )
    $content = Get-Content $filePath -Encoding UTF8 -Raw
    $originalContent = $content
    foreach ($pair in $replacements) {
        $content = [regex]::Replace($content, "(?i)$($pair.key)", $pair.value)
    }
    if ($content -ne $originalContent) {
        Set-Content $filePath $content -Encoding UTF8
        return $true
    }
    return $false
}

# Define replacements as array of pairs
$replacements = @(
    @{'key' = 'Janten Bersuara'; 'value' = 'Janten Bersuara'},
    @{'key' = 'jantenbersuara'; 'value' = 'jantenbersuara'},
    @{'key' = 'jantenbersuara'; 'value' = 'JantenBersuara'},
    @{'key' = 'jantenbersuara@gmail.com'; 'value' = 'jantenbersuara@gmail.com'},
    @{'key' = '- Janten Bersuara'; 'value' = '- Janten Bersuara'},
    @{'key' = [char]0x201C; 'value' = '"'},
    @{'key' = [char]0x201D; 'value' = '"'},
    @{'key' = [char]0x2018; 'value' = "'"},
    @{'key' = [char]0x2019; 'value' = "'"},
    @{'key' = [char]0x2013; 'value' = '-'},
    @{'key' = [char]0x2014; 'value' = '-'},
    @{'key' = '\uFFFD'; 'value' = ' '},
    @{'key' = '\u00A0'; 'value' = ' '},
    @{'key' = '<img[^>]*src="[^"]*logo\.png"[^>]*>'; 'value' = ''},
    @{'key' = 'img/logo\.png'; 'value' = ''},
    @{'key' = '<a class="navbar-brand"><span style="font-weight: bold; color: #B91C1C;">JANTEN</span> <span style="color: #1F5F2F;">BERSUARA</span></a>'; 'value' = '<a class="navbar-brand"><span style="font-weight: bold; color: #B91C1C;">JANTEN</span> <span style="color: #1F5F2F;">BERSUARA</span></a>'}
)

# Process HTML files
Get-ChildItem -Recurse -Include *.html | ForEach-Object {
    $changed = Replace-InFile -filePath $_.FullName -replacements $replacements
    if ($changed) {
        if ($_.DirectoryName -eq (Get-Location).Path) {
            $filesChanged.mainPages++
        } elseif ($_.DirectoryName -like "*article*") {
            $filesChanged.articlePages++
        }
    }
}

# Process CSS files
Get-ChildItem -Recurse -Include *.css | ForEach-Object {
    $cssReplacements = @{
        '--primary:\s*[^;]+' = '--primary: #B91C1C'
        '--dark:\s*[^;]+' = '--dark: #3F0D0D'
        '--secondary:\s*[^;]+' = '--secondary: #1F5F2F'
        '#FFCC00' = '#B91C1C'
        '#1E2024' = '#3F0D0D'
    }
    $changed = Replace-InFile -filePath $_.FullName -replacements $cssReplacements
    if ($changed) {
        $filesChanged.css++
    }
}

# Process package.json files
Get-ChildItem -Recurse -Include package.json | ForEach-Object {
    $packageReplacements = @{
        '"name":\s*"[^"]*"' = '"name": "jantenbersuara"'
    }
    $changed = Replace-InFile -filePath $_.FullName -replacements $packageReplacements
    if ($changed) {
        $filesChanged.package++
    }
}

# Process documentation files
Get-ChildItem -Recurse -Include *.md,*.ps1,*.txt | ForEach-Object {
    $changed = Replace-InFile -filePath $_.FullName -replacements $replacements
    if ($changed) {
        $filesChanged.docs++
    }
}

# Process netlify.toml
if (Test-Path "netlify.toml") {
    $changed = Replace-InFile -filePath "netlify.toml" -replacements $replacements
    if ($changed) {
        $filesChanged.docs++
    }
}

# Verification
$verificationResults = @{
    jantenbersuara = (Get-ChildItem -Recurse -Include *.html,*.css,*.js,*.json,*.md | Select-String -Pattern 'Janten Bersuara|jantenbersuara|jantenbersuara' -CaseSensitive:$false).Count
    logoPng = (Get-ChildItem -Recurse -Include *.html,*.css,*.js,*.json,*.md | Select-String -Pattern 'logo\.png').Count
    newColors = (Get-ChildItem -Recurse -Include *.css | Select-String -Pattern '#B91C1C|#3F0D0D|#1F5F2F').Count
}

# Output results
Write-Host "Files changed:"
Write-Host "Main pages: $($filesChanged.mainPages)"
Write-Host "Article pages: $($filesChanged.articlePages)"
Write-Host "CSS: $($filesChanged.css)"
Write-Host "Package: $($filesChanged.package)"
Write-Host "Docs: $($filesChanged.docs)"
Write-Host ""
Write-Host "Verification:"
Write-Host "Remaining 'Janten Bersuara' references: $($verificationResults.jantenbersuara)"
Write-Host "Remaining 'logo.png' references: $($verificationResults.logoPng)"
Write-Host "New color usages: $($verificationResults.newColors)"
Write-Host ""
Write-Host "Rebrand Janten Bersuara selesai ✅"
