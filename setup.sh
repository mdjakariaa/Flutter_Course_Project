#!/bin/bash
# Mess Management System - Supabase Integration
# Quick Start Script
# Run this to get started quickly!

echo "🚀 Mess Management System - Supabase Integration"
echo "=================================================="
echo ""

# Step 1: Check if Flutter is installed
echo "✓ Checking Flutter installation..."
flutter --version
if [ $? -ne 0 ]; then
    echo "❌ Flutter not found! Please install Flutter first."
    exit 1
fi
echo "✓ Flutter OK"
echo ""

# Step 2: Get dependencies
echo "✓ Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to get dependencies"
    exit 1
fi
echo "✓ Dependencies installed"
echo ""

# Step 3: Clean build
echo "✓ Cleaning build..."
flutter clean
echo "✓ Build cleaned"
echo ""

# Step 4: Analyze code
echo "✓ Analyzing code..."
flutter analyze
echo "✓ Code analysis complete"
echo ""

# Display next steps
echo "=================================================="
echo "✅ Setup Complete!"
echo "=================================================="
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. 📱 Set up Supabase Database:"
echo "   - Open Supabase Dashboard"
echo "   - Go to SQL Editor"
echo "   - Run the contents of: SUPABASE_SCHEMA.sql"
echo ""
echo "2. ▶️  Run the app:"
echo "   flutter run"
echo ""
echo "3. 🧪 Test the features:"
echo "   - Sign up with a test account"
echo "   - Create members and expenses"
echo "   - Verify calculations"
echo "   - Check Supabase dashboard"
echo ""
echo "4. 📚 Read Documentation:"
echo "   - SETUP_CHECKLIST.md - Quick reference"
echo "   - SUPABASE_INTEGRATION_GUIDE.md - Detailed guide"
echo "   - IMPLEMENTATION_NOTES.md - Technical details"
echo ""
echo "=================================================="
echo "ℹ️  Supabase Credentials:"
echo "=================================================="
echo ""
echo "URL: https://ibkjfbbcvhtyemvpgwcf.supabase.co"
echo "Key: sb_publishable_jJv2nPMnuXOpRrhutK9q6A_lNkKkgSr"
echo ""
echo "⚠️  Note: These credentials are pre-configured in the app."
echo "For production, create your own Supabase project."
echo ""
echo "=================================================="
echo "🎉 Ready to go! Happy coding!"
echo "=================================================="
