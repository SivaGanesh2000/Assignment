-- Rollback: v2 → v1
-- Cleanly removes added schema changes

BEGIN;

-- 1. Drop user_tier column
ALTER TABLE users
DROP COLUMN IF EXISTS user_tier;

-- 2. Drop processed_at column
ALTER TABLE orders
DROP COLUMN IF EXISTS processed_at;

-- 3. Drop index on orders(created_at)
DROP INDEX IF EXISTS idx_orders_created_at;

COMMIT;

-- ✅ Validation after rollback
SELECT column_name FROM information_schema.columns
WHERE table_name='users' AND column_name='user_tier';

SELECT column_name FROM information_schema.columns
WHERE table_name='orders' AND column_name='processed_at';

SELECT indexname FROM pg_indexes WHERE tablename='orders';
