@echo off
REM Mess Management System - Supabase Integration
REM Quick Start Script for Windows
REM Run this to get started quickly!

title Mess Manager - Supabase Integration Setup

echo.
echo ══════════════════════════════════════════════════════════
echo  🚀 Mess Management System - Supabase Integration
echo ══════════════════════════════════════════════════════════
echo.

REM Step 1: Check if Flutter is installed
echo [Step 1/4] ✓ Checking Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter not found! Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo ✓ Flutter OK
echo.

REM Step 2: Get dependencies
echo [Step 2/4] ✓ Installing dependencies...
call flutter pub get
if errorlevel 1 (
    echo ❌ Failed to get dependencies
    pause
    exit /b 1
)
echo ✓ Dependencies installed
echo.

REM Step 3: Clean build
echo [Step 3/4] ✓ Cleaning build...
call flutter clean
echo ✓ Build cleaned
echo.

REM Step 4: Analyze code
echo [Step 4/4] ✓ Analyzing code...
call flutter analyze
echo ✓ Code analysis complete
echo.

REM Display next steps
echo ══════════════════════════════════════════════════════════
echo  ✅ Setup Complete!
echo ══════════════════════════════════════════════════════════
echo.
echo 📋 NEXT STEPS:
echo.
echo 1. 📱 Set up Supabase Database:
echo    - Open Supabase Dashboard: https://app.supabase.com
echo    - Go to SQL Editor
echo    - Run the contents of: SUPABASE_SCHEMA.sql
echo    - Verify all tables are created
echo.
echo 2. ▶️  Run the app:
echo    Command: flutter run
echo.
echo 3. 🧪 Test the features:
echo    - Sign up with a test account
echo    - Create members and expenses
echo    - Verify calculations
echo    - Check Supabase dashboard
echo.
echo 4. 📚 Read Documentation:
echo    - SETUP_CHECKLIST.md
echo    - SUPABASE_INTEGRATION_GUIDE.md
echo    - IMPLEMENTATION_NOTES.md
echo.
echo ══════════════════════════════════════════════════════════
echo  ℹ️  Supabase Credentials (Pre-configured):
echo ══════════════════════════════════════════════════════════
echo.
echo URL: https://ibkjfbbcvhtyemvpgwcf.supabase.co
echo Key: sb_publishable_jJv2nPMnuXOpRrhutK9q6A_lNkKkgSr
echo.
echo ⚠️  For production, create your own Supabase project.
echo.
echo ══════════════════════════════════════════════════════════
echo  📌 Useful Commands:
echo ══════════════════════════════════════════════════════════
echo.
echo flutter run -v                   (Run with verbose output)
echo flutter run --hot-reload         (Enable hot reload)
echo flutter analyze                  (Check code)
echo dart format .                    (Format code)
echo.
echo ══════════════════════════════════════════════════════════
echo  🎉 Ready to go! Happy coding!
echo ══════════════════════════════════════════════════════════
echo.
pause
