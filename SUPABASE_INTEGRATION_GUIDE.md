# Mess Management System - Supabase Integration

A Flutter application for managing shared expenses among mess (shared dining) members, fully integrated with Supabase for authentication and database management.

## Features

✅ **User Authentication**

- Secure sign up and login with Supabase Auth
- Email/password authentication
- Automatic session management
- Logout functionality

✅ **Member Management**

- Add and manage mess members
- Track meal counts per member
- Delete members (cascading delete of associated expenses)
- View all members with their meal counts

✅ **Expense Tracking**

- Add shared expenses
- Associate expenses with specific members (optional)
- View all expenses with dates and amounts
- Delete expenses
- Update expenses

✅ **Calculations**

- Automatic calculation of total expenses
- Total meal count tracking
- Per-meal cost calculation
- Per-member expense calculation

✅ **User Profile**

- View and edit user profile
- Account information display
- Statistics dashboard
- Dark/Light theme toggle

## Project Structure

```
lib/
├── main.dart                    # App entry point with Supabase initialization
├── models/
│   ├── member.dart             # Member model with JSON serialization
│   └── expense.dart            # Expense model with JSON serialization
├── providers/
│   ├── auth_provider.dart       # Authentication state management
│   └── mess_provider.dart       # Business logic state management
├── screens/
│   ├── home.dart               # Home/Members dashboard
│   ├── login.dart              # Login screen
│   ├── signup.dart             # Sign up screen
│   ├── add_member.dart         # Add member screen
│   ├── add_meal.dart           # Add meal count screen
│   ├── add_expense.dart        # Add expense screen
│   └── profile.dart            # User profile screen
├── services/
│   ├── supabase_config.dart    # Supabase configuration constants
│   ├── auth_service.dart       # Supabase authentication service
│   └── database_service.dart   # Supabase database operations
└── widgets/
    └── cart_widget.dart        # Summary statistics widget
```

## Setup Instructions

### Prerequisites

1. **Flutter SDK** (Latest stable version)
2. **Dart SDK** (3.9.2 or higher)
3. **Supabase Account** (Free tier available at https://supabase.com)

### Step 1: Clone the Project

```bash
cd "g:\LU\6th Semester\Smartphone Application Development\Mess_Meneging_System\mess_meneging_system"
```

### Step 2: Install Dependencies

```bash
flutter clean
flutter pub get
```

### Step 3: Set Up Supabase Project

1. **Create a Supabase Project**

   - Go to https://supabase.com
   - Sign up/Login
   - Create a new project

2. **Execute SQL Schema**

   - Open the SQL editor in Supabase
   - Copy the entire contents of `SUPABASE_SCHEMA.sql`
   - Run the SQL in the Supabase SQL editor
   - This will create all necessary tables and enable Row Level Security (RLS)

3. **Verify Credentials**
   - Project URL: https://[your-project].supabase.co
   - Anon Key: Found in Project Settings → API Keys → anon public key
   - These should match the values in `lib/services/supabase_config.dart`

### Step 4: Update Configuration (Optional)

If using a different Supabase project, update the credentials in [lib/services/supabase_config.dart](lib/services/supabase_config.dart):

```dart
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### Step 5: Run the App

```bash
flutter run
```

Or for a specific device/emulator:

```bash
flutter run -d <device_id>
```

## User Authentication Flow

1. **First Launch**: User sees authentication screen
2. **Sign Up**: User creates account with email, password, and full name
   - Account created in Supabase Auth
   - User profile created in database
3. **Login**: User authenticates with email and password
   - Session managed by Supabase
   - Automatic session persistence
4. **Authenticated State**: User redirected to home screen
5. **Logout**: User can logout, returning to auth screen

## Database Schema Overview

### Tables

#### `user_profiles`

- `id` (UUID): Primary key
- `user_id` (UUID): Foreign key to auth.users
- `email` (TEXT): User email
- `full_name` (TEXT): User's full name
- `avatar_url` (TEXT): Optional profile picture URL
- `created_at`, `updated_at`: Timestamps

#### `members`

- `id` (TEXT): Primary key (unique ID)
- `user_id` (UUID): Foreign key to auth.users
- `name` (TEXT): Member name
- `meal` (INTEGER): Total meal count
- `created_at`, `updated_at`: Timestamps

#### `expenses`

- `id` (TEXT): Primary key (unique ID)
- `user_id` (UUID): Foreign key to auth.users
- `title` (TEXT): Expense description
- `amount` (DECIMAL): Amount (> 0)
- `member_id` (TEXT): Foreign key to members (optional)
- `date` (TIMESTAMP): Expense date
- `created_at`, `updated_at`: Timestamps

### Security Policies

All tables have Row Level Security (RLS) enabled:

- Users can only view/modify their own data
- Members can only access their own members
- Expenses can only be accessed by the owner user
- Cascading deletes are implemented for data integrity

## Key Services

### AuthService ([lib/services/auth_service.dart](lib/services/auth_service.dart))

Handles all authentication operations:

- `signUp()`: Register new user
- `login()`: Authenticate user
- `logout()`: Sign out user
- `resetPassword()`: Reset forgotten password
- `updateProfile()`: Update user information
- `getUserProfile()`: Fetch user details
- `authStateChanges`: Stream of auth state changes

### DatabaseService ([lib/services/database_service.dart](lib/services/database_service.dart))

Manages all database operations:

**Members Operations**

- `getMembers()`: Fetch all members
- `addMember()`: Create new member
- `deleteMember()`: Delete member and associated expenses
- `addMeal()`: Update meal count

**Expenses Operations**

- `getExpenses()`: Fetch all expenses
- `addExpense()`: Create new expense
- `deleteExpense()`: Delete expense
- `updateExpense()`: Modify expense
- `getMemberExpenses()`: Get expenses for specific member

**Calculations**

- `getTotalExpense()`: Sum of all expenses
- `getTotalMeal()`: Sum of all meals
- `getPerMealCost()`: Cost per meal
- `getMemberExpenseAmount()`: Cost for specific member

### Providers

**AuthProvider** ([lib/providers/auth_provider.dart](lib/providers/auth_provider.dart))

- Manages authentication state
- Provides loading and error states
- Handles sign up, login, logout
- Manages user profile updates

**MessProvider** ([lib/providers/mess_provider.dart](lib/providers/mess_provider.dart))

- Manages business logic state
- Handles member and expense operations
- Provides calculations
- Manages theme state (dark/light mode)
- Supports both online (Supabase) and offline (local) operations

## Error Handling

The application implements comprehensive error handling:

1. **Network Errors**: Graceful handling of connectivity issues
2. **Validation Errors**: Input validation before submission
3. **Authentication Errors**: Clear error messages for auth failures
4. **Database Errors**: Proper error propagation and user feedback
5. **Form Validation**: Real-time feedback on input errors

All errors are displayed using SnackBar notifications and error containers in the UI.

## State Management

The app uses the **Provider pattern** for state management:

```
MultiProvider
├── AuthService (Singleton)
├── AuthProvider (ChangeNotifier)
│   └── Manages user authentication state
├── DatabaseService (ProxyProvider)
│   └── Created after authentication
└── MessProvider (ChangeNotifierProxyProvider)
    └── Depends on DatabaseService
```

This ensures:

- Single source of truth for state
- Automatic widget rebuilds on state changes
- Proper dependency injection
- Clean separation of concerns

## Testing the Integration

### Test User Credentials

After setting up, create a test account:

1. Sign up with:

   - Email: `test@example.com`
   - Password: `test123456`
   - Name: `Test User`

2. Test functionality:
   - Add members
   - Add expenses
   - Add meals
   - Calculate per-meal cost
   - View statistics
   - Update profile
   - Logout and login

### Debugging

Enable debug logging:

```bash
flutter run -v
```

Check Supabase logs in the dashboard:

- Project Settings → Logs
- View real-time database operations
- Monitor authentication events

## Best Practices Implemented

✅ **Security**

- Secure authentication with Supabase
- Row Level Security on all tables
- No sensitive data in client code
- Secure password handling

✅ **Code Quality**

- Clean architecture with services and providers
- Proper error handling and validation
- JSON serialization for models
- Type safety with null safety

✅ **Performance**

- Efficient database queries
- Pagination ready (extensible)
- Local caching support
- Minimal rebuilds with Consumer widgets

✅ **User Experience**

- Loading states and progress indicators
- Error messages and feedback
- Smooth transitions
- Responsive UI with proper spacing

✅ **Maintainability**

- Well-organized file structure
- Descriptive naming conventions
- Comments for complex logic
- Consistent code style

## Troubleshooting

### Supabase Connection Issues

1. **Verify credentials** in `supabase_config.dart`
2. **Check internet connection**
3. **Restart the app**: `flutter run --no-fast-start`
4. **Check Supabase project status** in dashboard

### Authentication Issues

1. **Ensure database tables are created** using the SQL schema
2. **Check RLS policies** are enabled
3. **Verify user profile table exists**
4. **Review Supabase logs** for error details

### Data Not Appearing

1. **Force refresh**: Pull-down to refresh on home screen
2. **Check RLS policies**: Ensure user can access their own data
3. **Verify user_id** matches in all table rows
4. **Check Supabase logs** for permission errors

## Future Enhancements

- [ ] Family/group sharing of expenses
- [ ] Detailed transaction history
- [ ] PDF expense reports
- [ ] Push notifications
- [ ] Offline sync with Supabase
- [ ] Image uploads for receipts
- [ ] Payment tracking and settlements
- [ ] Advanced analytics and charts

## Security Considerations

⚠️ **Important**: The API key used is a publishable key (anon key) with limited permissions. It can only:

- Access data based on Row Level Security policies
- Perform authentication operations

For production, additional security measures should be implemented:

- Custom RLS policies for different user roles
- Rate limiting on API calls
- Input sanitization
- Audit logging
- Regular security audits

## Support & Documentation

- **Flutter Documentation**: https://flutter.dev/docs
- **Supabase Documentation**: https://supabase.com/docs
- **Provider Package**: https://pub.dev/packages/provider
- **Supabase Flutter Package**: https://pub.dev/packages/supabase_flutter

## License

This project is provided as-is for educational purposes.

## Author

Created as part of the Smartphone Application Development course.

---

**Last Updated**: January 2, 2026
**Flutter Version**: Latest
**Dart Version**: 3.9.2+
**Supabase**: All plans supported
