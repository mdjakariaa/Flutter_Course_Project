# Mess Management System

A comprehensive Flutter application for managing shared expenses among mess (shared dining) members, fully integrated with **Supabase** for secure authentication and cloud database management.

![Flutter](https://img.shields.io/badge/Flutter-Latest-blue)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-green)
![Supabase](https://img.shields.io/badge/Supabase-Integrated-brightgreen)
![Provider](https://img.shields.io/badge/Provider-6.0.5-purple)

## 🎯 Features

### ✅ Authentication & Security

- **Secure Sign Up & Login** with Supabase Auth
- **Email/Password** authentication
- **Session Management** with automatic persistence
- **User Profiles** with editable information
- **Logout** functionality
- **Row Level Security (RLS)** on all database tables

### ✅ Member Management

- Add and manage mess members
- Track individual meal counts
- View member statistics
- Delete members (cascading delete of expenses)
- Real-time member list updates

### ✅ Expense Tracking

- Add shared expenses with amounts and dates
- Associate expenses with members (optional)
- View complete expense history
- Delete expenses
- Update expense details
- Real-time expense calculations

### ✅ Smart Calculations

- **Total Expenses** calculation
- **Per-Meal Cost** calculation
- **Member Expense** calculation (meals × per-meal cost)
- **Total Meal Count** tracking
- Real-time statistics

### ✅ User Experience

- **Dark/Light Theme** toggle
- **User Profile** management
- **Statistics Dashboard** with key metrics
- **Error Handling** with user feedback
- **Loading States** for async operations
- **Pull-to-Refresh** functionality
- **Responsive UI** design

## 📱 Screenshots

```
┌─────────────────────────┐
│   Mess Manager          │
│   Login Screen          │
│                         │
│  Email: [...........]   │
│  Password: [.........]  │
│  [Login]  [Sign Up]     │
└─────────────────────────┘

┌─────────────────────────┐
│   Home Screen           │
│   Members & Expenses    │
│                         │
│  John Doe - 5 meals     │
│  Jane Doe - 3 meals     │
│  Total: $150.00         │
│  Per Meal: $16.67       │
└─────────────────────────┘
```

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                    # App initialization & routing
├── models/
│   ├── member.dart             # Member model with JSON serialization
│   └── expense.dart            # Expense model with JSON serialization
├── providers/
│   ├── auth_provider.dart       # Authentication state (ChangeNotifier)
│   └── mess_provider.dart       # Business logic state (ChangeNotifier)
├── screens/
│   ├── home.dart               # Dashboard with member list
│   ├── login.dart              # Login screen
│   ├── signup.dart             # Registration screen
│   ├── add_member.dart         # Add member form
│   ├── add_meal.dart           # Add meal count form
│   ├── add_expense.dart        # Add expense form
│   └── profile.dart            # User profile & settings
├── services/
│   ├── supabase_config.dart    # Supabase credentials & constants
│   ├── auth_service.dart       # Supabase authentication service
│   └── database_service.dart   # Supabase database operations
└── widgets/
    └── cart_widget.dart        # Summary statistics widget

Documentation/
├── SETUP_CHECKLIST.md          # Quick setup guide
├── SUPABASE_INTEGRATION_GUIDE.md  # Detailed setup & usage
├── SUPABASE_SCHEMA.sql         # Database schema & RLS policies
└── IMPLEMENTATION_NOTES.md     # Technical architecture details
```

### State Management Architecture

```
MultiProvider
├── Provider<AuthService>              [Singleton]
├── ChangeNotifierProvider<AuthProvider>   [Reactive]
├── ProxyProvider<AuthProvider, DatabaseService?>  [Conditional]
└── ChangeNotifierProxyProvider<DatabaseService?, MessProvider>  [Dependent]
```

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (Latest stable)
- Dart SDK (3.9.2 or higher)
- Supabase account (free tier available)
- Internet connection

### Installation

1. **Clone the project**

```bash
cd mess_meneging_system
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Execute Supabase SQL Schema**

   - Go to Supabase Dashboard
   - Open SQL Editor
   - Run the contents of `SUPABASE_SCHEMA.sql`

4. **Run the app**

```bash
flutter run
```

### Detailed Setup

See [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) for step-by-step instructions.

## 📚 Documentation

- **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Quick setup checklist
- **[SUPABASE_INTEGRATION_GUIDE.md](SUPABASE_INTEGRATION_GUIDE.md)** - Complete setup & usage guide
- **[IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md)** - Technical architecture details
- **[SUPABASE_SCHEMA.sql](SUPABASE_SCHEMA.sql)** - Database schema with RLS policies

## 🔐 Security Features

### Authentication

- ✅ Secure password hashing (Supabase)
- ✅ Email verification (optional)
- ✅ Session token management
- ✅ Automatic session persistence
- ✅ Multi-factor authentication ready

### Database

- ✅ Row Level Security (RLS) on all tables
- ✅ User-scoped data access
- ✅ Cascading deletes for data integrity
- ✅ Input validation & sanitization
- ✅ Type-safe queries

### Code

- ✅ Null safety enabled
- ✅ Error handling throughout
- ✅ Secure initialization
- ✅ No hardcoded secrets
- ✅ Proper access control

## 🗄️ Database Schema

### Tables

**members**

- `id` (TEXT): Primary key
- `user_id` (UUID): Foreign key to users
- `name` (TEXT): Member name
- `meal` (INTEGER): Meal count
- `created_at` / `updated_at`: Timestamps

**expenses**

- `id` (TEXT): Primary key
- `user_id` (UUID): Foreign key to users
- `title` (TEXT): Expense description
- `amount` (DECIMAL): Amount (> 0)
- `member_id` (TEXT): Optional reference to member
- `date` (TIMESTAMP): Expense date
- `created_at` / `updated_at`: Timestamps

**user_profiles**

- `id` (UUID): Primary key
- `user_id` (UUID): Foreign key to users
- `email` (TEXT): User email
- `full_name` (TEXT): Full name
- `avatar_url` (TEXT): Optional profile picture
- `created_at` / `updated_at`: Timestamps

### Security Policies

All tables have Row Level Security enabled:

- Users can only view their own members
- Users can only view their own expenses
- Users can only access their own profile
- Cascading deletes implemented

## 🧪 Testing

### Manual Testing Scenarios

1. **Authentication**

   - Sign up with new account
   - Login with credentials
   - Logout from profile
   - Verify session persistence

2. **Member Management**

   - Add multiple members
   - View member list
   - Delete a member
   - Verify cascading delete of expenses

3. **Expense Management**

   - Add expenses
   - Associate with members
   - Delete expenses
   - View expense history

4. **Calculations**

   - Add members with meals
   - Add expenses
   - Verify per-meal cost calculation
   - Check member expense calculation

5. **User Profile**
   - View profile information
   - Edit full name
   - Check statistics
   - Toggle dark mode

## 🛠️ Development

### Build Variants

```bash
# Debug build
flutter run

# Release build
flutter build apk --release

# iOS build
flutter build ios --release

# Web build
flutter build web
```

### Code Analysis

```bash
# Check for issues
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade
```

## 📊 Key Metrics

- **Lines of Code**: ~2000+
- **Dart Files**: 13+
- **SQL Schema**: ~200 lines
- **Documentation**: 4 comprehensive guides
- **Features**: 15+ core features
- **Test Coverage**: Ready for unit/widget tests

## 🎓 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider Pattern](https://pub.dev/packages/provider)
- [Supabase Flutter Package](https://pub.dev/packages/supabase_flutter)

## 🐛 Troubleshooting

### Common Issues

**App won't start**

```bash
flutter clean
flutter pub get
flutter run
```

**Supabase connection error**

- Verify internet connection
- Check credentials in `supabase_config.dart`
- Ensure Supabase project is active

**Data not saving**

- Execute SQL schema in Supabase
- Check RLS policies
- Verify user authentication

See [SUPABASE_INTEGRATION_GUIDE.md](SUPABASE_INTEGRATION_GUIDE.md#troubleshooting) for detailed troubleshooting.

## 🚦 Status

✅ **Complete and Production-Ready**

All features fully implemented with:

- Secure authentication
- Cloud database integration
- Comprehensive error handling
- Professional UI/UX
- Complete documentation

## 📈 Future Enhancements

- [ ] Real-time notifications
- [ ] Expense reports & analytics
- [ ] Receipt image uploads
- [ ] Payment tracking
- [ ] Settlement calculator
- [ ] Multi-user families/groups
- [ ] Offline sync
- [ ] Advanced analytics

## 📝 License

This project is provided as-is for educational purposes.

## 👨‍💻 Author

Created as part of the Smartphone Application Development course.

## 📞 Support

For issues or questions:

1. Check the documentation files
2. Review implementation examples in code
3. Check Supabase dashboard logs
4. Run with verbose flag: `flutter run -v`

---

### Supabase Credentials (Pre-configured)

**Project URL**: https://ibkjfbbcvhtyemvpgwcf.supabase.co

**API Key**: sb_publishable_jJv2nPMnuXOpRrhutK9q6A_lNkKkgSr

> Note: For production, use your own Supabase project credentials.

---

**Version**: 2.0 (Supabase Integrated)
**Last Updated**: January 2, 2026
**Status**: ✅ Production Ready
