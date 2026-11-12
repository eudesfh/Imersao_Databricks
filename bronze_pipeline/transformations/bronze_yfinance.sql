
CREATE OR REFRESH STREAMING LIVE TABLE yfinance
TBLPROPERTIES ("quality" = "bronze")

-- Lê os arquivos JSON da pasta RAW usando cloud_files (Auto Loader)

SELECT *
FROM cloud_files(
	'/Volumes/lakehouse/raw_public/yfinance/commodities/latest_prices/',
	-- Caminho de origem
	'json',
	map(
	-- Ingestão incremental:
	-- Se "false", o DLT vai processar apenas os novos arquivos
	-- que chegarem após o pipeline começar.
	'cloudFiles.includeExistingFiles', 'false',

	-- Detecta automaticamente o tipo das colunas (útil em JSON)
	'cloudFiles.inferColumnTypes', 'true',

	-- Permite adicionar novas colunas automaticamente (tem também o rescue)
	-- Se o schema do JSON mudar no futuro
	'cloudFiles.schemaEvolutionMode', 'addNewColumns'
	)
);
