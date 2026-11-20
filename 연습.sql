-- 요금제별로 «고객 한 명이 한 해(2025) 평균 몇 번 문의했나»
-- 조인 규칙: 문의를 고객별로 먼저 집계하고, customers 를 왼쪽에 둔 LEFT JOIN
-- 문의가 한 번도 없는 고객(26,602명)은 0건으로 세어 분모에 넣는다
WITH t AS (
  SELECT customer_id, COUNT(*) AS 문의수
  FROM support_tickets
  GROUP BY customer_id
)
SELECT c.plan_type AS 요금제,
       COUNT(*) AS 고객,
       SUM(COALESCE(t.문의수, 0)) AS 문의,
       ROUND(AVG(COALESCE(t.문의수, 0)), 2) AS 고객당_문의
FROM customers c
LEFT JOIN t USING (customer_id)
GROUP BY c.plan_type
ORDER BY 고객당_문의 DESC
