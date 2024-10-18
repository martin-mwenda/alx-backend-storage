-- Task: List all Glam rock bands ranked by their lifespan
-- The lifespan is calculated based on the 'formed' and 'split' columns.
-- If the band has not split (NULL value in 'split'), we consider they are active until 2022.

SELECT 
    name AS band_name, 
    CASE 
        WHEN split IS NULL THEN 2022 - formed 
        ELSE split - formed 
    END AS lifespan
FROM 
    metal_bands
WHERE 
    style = 'Glam rock'
ORDER BY 
    lifespan DESC;
