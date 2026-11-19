CREATE OR REFRESH STREAMING LIVE TABLE bronze.sales_commodities
TBLPROPERTIES ("quality" = "bronze")
AS
SELECT
  *,
  current_timestamp() AS ingestion_ts_utc
FROM STREAM(lakehouse.postgres_db_public.sales_commodities);