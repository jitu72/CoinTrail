@echo off
echo ========================================
echo       SPENDIFY FLUTTER APP RUNNER
echo ========================================
echo.

cd /d "c:\Users\Jihadul Islam\StudioProjects\spendify"

echo [1/5] Checking Flutter installation...
flutter --version
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    pause
    exit /b 1
)

echo.
echo [2/5] Cleaning previous build...
flutter clean

echo.
echo [3/5] Getting dependencies...
flutter pub get

echo.
echo [4/5] Checking available devices...
flutter devices

echo.
echo [5/5] Running the app...
echo Note: If build fails, try running: flutter run -d windows (for desktop) or flutter run -d chrome (for web)
echo.
flutter run

echo.
echo ========================================
echo App execution completed!
echo ========================================
pause
