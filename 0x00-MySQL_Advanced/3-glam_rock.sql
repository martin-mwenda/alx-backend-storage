-- Task: List all Glam rock bands ranked by their lifespan
-- The lifespan is calculated based on the 'formed' and 'split' columns.
-- If the band has not split (NULL value in 'split'), we consider they are active until 2022.

SELECT `band_name`, (IFNULL(`split`, '2022') - `formed`) AS `lifespan`
    FROM `metal_bands` WHERE FIND_IN_SET('Glam rock', IFNULL(`style`, "")) > 0
    ORDER BY `lifespan` DESC;
