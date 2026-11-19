
CREATE OR REFRESH STREAMING LIVE TABLE bronze.yfinance
TBLPROPERTIES ("quality" = "bronze")
AS
SELECT *
FROM cloud_files(
	'/Volumes/lakehouse/raw_public/yfinance/commodities/latest_prices/',
	'json',
	map(
	'cloudFiles.includeExistingFiles', 'true',
	'cloudFiles.inferColumnTypes', 'true',
	'cloudFiles.schemaEvolutionMode', 'addNewColumns'
	)
);