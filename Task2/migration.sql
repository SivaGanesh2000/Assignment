-- Migration from v1 → v2
-- Safe to run multiple times

BEGIN;

-- 1. Add user_tier column to users table
ALTER TABLE users
ADD COLUMN IF NOT EXISTS user_tier VARCHAR DEFAULT 'free';

-- 2. Add processed_at column to orders table
ALTER TABLE orders
ADD COLUMN IF NOT EXISTS processed_at TIMESTAMP NULL;

-- 3. Create index on orders(created_at)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes WHERE tablename = 'orders' AND indexname = 'idx_orders_created_at'
    ) THEN
        CREATE INDEX idx_orders_created_at ON orders(created_at);
    END IF;
END$$;

-- 4. Backfill processed_at for completed orders
UPDATE orders
SET processed_at = created_at + INTERVAL '2 hours'
WHERE status = 'completed'
  AND processed_at IS NULL;

COMMIT;

