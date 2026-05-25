-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: copied from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205


-- #############################
-- DELETE bay
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteBay;

DELIMITER //
CREATE PROCEDURE sp_DeleteBay(IN p_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
       
        DELETE FROM Bays WHERE bayId = p_id;
    

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Bays for id: ', p_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;