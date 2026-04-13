# ============================================
# SCRIPT OTOMATIS PUSH KE GITHUB
# ============================================
# Cara pakai:
# 1. Letakkan file ini di root folder project
# 2. Buka PowerShell di folder project
# 3. Jalankan: .\push-to-github.ps1
# ============================================

param(
    [string]$message = "Update: Automatic push dari PowerShell"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  OTOMATIS PUSH KE GITHUB" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# 1. Check git status
Write-Host "`n[1/6] Check git status..." -ForegroundColor Yellow
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Host "✓ Working tree clean (tidak ada perubahan)" -ForegroundColor Green
    exit 0
}

Write-Host "✓ Ditemukan perubahan:" -ForegroundColor Green
git status --short

# 2. Add semua file
Write-Host "`n[2/6] Add semua file..." -ForegroundColor Yellow
git add -A
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Files ditambahkan" -ForegroundColor Green
} else {
    Write-Host "✗ Error saat add files" -ForegroundColor Red
    exit 1
}

# 3. Commit
Write-Host "`n[3/6] Commit dengan pesan: '$message'" -ForegroundColor Yellow
git commit -m $message
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Commit berhasil" -ForegroundColor Green
} else {
    Write-Host "✗ Error saat commit" -ForegroundColor Red
    exit 1
}

# 4. Pull dari remote (untuk sinkronisasi)
Write-Host "`n[4/6] Pull dari remote..." -ForegroundColor Yellow
git pull origin main 2>&1 | Tee-Object -Variable pullOutput
if ($pullOutput -match "conflict") {
    Write-Host "⚠ Ada conflict, mencoba resolve..." -ForegroundColor Yellow
    git add -A
    git commit -m "Resolve merge conflict"
}

# 5. Push ke remote
Write-Host "`n[5/6] Push ke GitHub..." -ForegroundColor Yellow
git push origin main
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Push berhasil!" -ForegroundColor Green
} else {
    Write-Host "✗ Error saat push" -ForegroundColor Red
    exit 1
}

# 6. Verifikasi
Write-Host "`n[6/6] Verifikasi status..." -ForegroundColor Yellow
$finalStatus = git status
if ($finalStatus -match "working tree clean" -or $finalStatus -match "nothing to commit") {
    Write-Host "✓ Semua selesai! Working tree clean" -ForegroundColor Green
} else {
    Write-Host "⚠ Warning: Ada file yang tidak tercek" -ForegroundColor Yellow
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  SELESAI!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "`nLihat di: https://github.com/alfinsya/indonesiadaily" -ForegroundColor Magenta
