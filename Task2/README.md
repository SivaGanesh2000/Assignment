## Pre-Requisites

- Ensure you have access to the target PostgreSQL database.

- Set required environment variables:

    ``` sh
    PGHOST (database host)

    PGPORT (port, default 5432)

    PGUSER (username)

    PGPASSWORD (password)

    PGDATABASE (database name)
    ```

#### Run migration:

```bash
psql -f migration.sql
```

#### To rollback:

```bash
psql -f rollback.sql
```
#### Validation
Scripts include checks for:

- Row counts (users, orders)
- Column existence (user_tier, processed_at)
- Index existence (idx_orders_created_at)

``` sql
-- Pre/Post Validation Checks
-- Row counts
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS order_count FROM orders;

-- Column existence
SELECT column_name FROM information_schema.columns
WHERE table_name='users' AND column_name='user_tier';

SELECT column_name FROM information_schema.columns
WHERE table_name='orders' AND column_name='processed_at';

-- Index existence
SELECT indexname FROM pg_indexes WHERE tablename='orders';
```

#### Estimated Runtime

For a 1M-row orders table: adding columns is negligible (<1s). Creating index may take seconds to a min depending on hardware.
- Backfill update takes more time than above two, as it a sequential update.