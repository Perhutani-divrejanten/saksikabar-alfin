@echo off
REM ============================================
REM SCRIPT BATCH UNTUK PUSH KE GITHUB
REM ============================================
REM Simpan file ini di root folder project
REM Double-click untuk menjalankan otomatis push
REM ============================================

setlocal enabledelayedexpansion

echo.
echo ======================================
echo   AUTO PUSH KE GITHUB
echo ======================================
echo.

REM Check git tersedia
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git tidak terinstall
    pause
    exit /b 1
)

REM Add all files
echo [1/4] Adding files...
git add -A
if %errorlevel% neq 0 (
    echo [ERROR] Gagal add files
    pause
    exit /b 1
)
echo [OK] Files ditambahkan

REM Commit
echo [2/4] Committing...
set /p commit_msg="Masukkan commit message (atau Enter untuk default): "
if "!commit_msg!"=="" (
    set commit_msg=Update: Automatic push
)
git commit -m "!commit_msg!"
if %errorlevel% neq 0 (
    echo [ERROR] Gagal commit
    pause
    exit /b 1
)
echo [OK] Commit berhasil

REM Pull
echo [3/4] Pulling from remote...
git pull origin main
if %errorlevel% neq 0 (
    echo [WARNING] Ada conflict, resolve manual atau skip
)
echo [OK] Pull complete

REM Push
echo [4/4] Pushing to GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo [ERROR] Gagal push
    pause
    exit /b 1
)
echo [OK] Push berhasil!

echo.
echo ======================================
echo   SELESAI!
echo ======================================
echo Lihat: https://github.com/alfinsya/indonesiadaily
echo.
pause
