-- Task: Create a trigger to decrease the quantity of an item when a new order is added
-- This trigger will run after a new row is inserted into the 'orders' table
-- It will reduce the quantity of the corresponding item in the 'items' table

DELIMITER //

CREATE TRIGGER decrease_item_quantity_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE items
    SET quantity = quantity - NEW.quantity_ordered
    WHERE id = NEW.item_id;
END //

DELIMITER ;
