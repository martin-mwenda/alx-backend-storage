-- Task: Rank country origins of bands by the total number of non-unique fans
-- This query calculates the total number of fans per country (origin) and orders them in descending order

SELECT origin, SUM(fans) AS nb_fans
FROM metal_bands
GROUP BY origin
ORDER BY nb_fans DESC;
