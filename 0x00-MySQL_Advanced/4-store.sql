-- Task: Create a trigger to decrease the quantity of an item when a new order is added
-- This trigger will run after a new row is inserted into the 'orders' table
-- It will reduce the quantity of the corresponding item in the 'items' table

DELIMITER //
CREATE TRIGGER `reduce_order_qty` AFTER INSERT ON `orders`
    FOR EACH ROW
    BEGIN
        UPDATE `items` SET `quantity` = `quantity` - NEW.number
        WHERE `name` = NEW.item_name;
    END;
//
DELIMITER ;
