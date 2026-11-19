CREATE OR REFRESH MATERIALIZED VIEW gold.mostvaluableclient AS
SELECT
  customer_sk,
  COUNT(*) AS total_transacoes,
  ROUND(SUM(gross_value), 2) AS valor_total,
  ROUND(AVG(gross_value), 2) AS ticket_medio,
  MIN(data_hora) AS primeira_transacao,
  MAX(data_hora) AS ultima_transacao,
  COUNT(CASE
    WHEN data_hora >= (SELECT MAX(data_hora) FROM lakehouse.silver.fact_transaction_revenue) - INTERVAL 30 DAYS THEN 1
  END) AS transacoes_ultimos_30_dias,
  ROUND(SUM(fee_revenue), 2) AS comissao_total,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking_por_transacoes,
  CASE
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 1 THEN 'Top 1'
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 2 THEN 'Top 2'
    WHEN RANK() OVER (ORDER BY COUNT(*) DESC) = 3 THEN 'Top 3'
    ELSE 'Outros'
  END AS classificacao_cliente,
  current_timestamp() AS calculated_at
FROM lakehouse.silver.fact_transaction_revenue
GROUP BY customer_sk;