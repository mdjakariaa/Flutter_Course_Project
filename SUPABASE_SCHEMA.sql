-- Mess Management System - Supabase SQL Schema
-- This schema sets up the required tables with proper security policies

-- ===============================================================
-- 1. USER PROFILES TABLE (Extension of Supabase Auth Users)
-- ===============================================================
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);

-- ===============================================================
-- 2. MEMBERS TABLE
-- ===============================================================
CREATE TABLE IF NOT EXISTS members (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  meal INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_members_user_id ON members(user_id);
CREATE INDEX IF NOT EXISTS idx_members_created_at ON members(created_at DESC);

-- ===============================================================
-- 3. EXPENSES TABLE
-- ===============================================================
CREATE TABLE IF NOT EXISTS expenses (
  id TEXT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
  member_id TEXT REFERENCES members(id) ON DELETE SET NULL,
  date TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_expenses_user_id ON expenses(user_id);
CREATE INDEX IF NOT EXISTS idx_expenses_member_id ON expenses(member_id);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_created_at ON expenses(created_at DESC);

-- ===============================================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES
-- ===============================================================

-- Enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;

-- ===============================================================
-- USER PROFILES POLICIES
-- ===============================================================

-- Policy: Users can view their own profile
CREATE POLICY "Users can view their own profile"
  ON user_profiles
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own profile
CREATE POLICY "Users can insert their own profile"
  ON user_profiles
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update their own profile"
  ON user_profiles
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ===============================================================
-- MEMBERS POLICIES
-- ===============================================================

-- Policy: Users can view their own members
CREATE POLICY "Users can view their own members"
  ON members
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert members
CREATE POLICY "Users can insert members"
  ON members
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own members
CREATE POLICY "Users can update their own members"
  ON members
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own members
CREATE POLICY "Users can delete their own members"
  ON members
  FOR DELETE
  USING (auth.uid() = user_id);

-- ===============================================================
-- EXPENSES POLICIES
-- ===============================================================

-- Policy: Users can view their own expenses
CREATE POLICY "Users can view their own expenses"
  ON expenses
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert expenses
CREATE POLICY "Users can insert expenses"
  ON expenses
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own expenses
CREATE POLICY "Users can update their own expenses"
  ON expenses
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own expenses
CREATE POLICY "Users can delete their own expenses"
  ON expenses
  FOR DELETE
  USING (auth.uid() = user_id);

-- ===============================================================
-- 5. FUNCTIONS (Optional - for advanced operations)
-- ===============================================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_members_updated_at
  BEFORE UPDATE ON members
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at
  BEFORE UPDATE ON expenses
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ===============================================================
-- COMMENTS
-- ===============================================================

COMMENT ON TABLE user_profiles IS 'Extended user profile information';
COMMENT ON TABLE members IS 'Mess members tracking meal counts';
COMMENT ON TABLE expenses IS 'Shared expenses for the mess';

COMMENT ON COLUMN user_profiles.full_name IS 'Full name of the user';
COMMENT ON COLUMN members.name IS 'Name of the member';
COMMENT ON COLUMN members.meal IS 'Total meal count for the member';
COMMENT ON COLUMN expenses.amount IS 'Expense amount (must be > 0)';
COMMENT ON COLUMN expenses.member_id IS 'Optional: Associated member for the expense';
