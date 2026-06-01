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


-- #############################
-- UPDATE bay
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateBay;

DELIMITER //
CREATE PROCEDURE sp_UpdateBay(
    IN p_id          INT,
    IN p_name        VARCHAR(30),
    IN p_handedness  VARCHAR(10),
    IN p_active      CHAR(1)
)
BEGIN
    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the error to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        -- COALESCE keeps the existing column value when a parameter is NULL,
        -- allowing partial updates (only changed fields need to be passed in)
        UPDATE Bays
        SET name        = COALESCE(p_name, name),
            handedness  = COALESCE(p_handedness, handedness),
            active      = COALESCE(p_active, active)
        WHERE bayId = p_id;

    COMMIT;

END //
DELIMITER ;


-- #############################
-- CREATE customer
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateCustomer;

DELIMITER //
CREATE PROCEDURE sp_CreateCustomer(
    IN p_firstName    VARCHAR(140),
    IN p_lastName     VARCHAR(140),
    IN p_email        VARCHAR(140),
    IN p_phone        VARCHAR(45),
    IN p_membershipId INT
)
BEGIN
    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propagate the error to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        INSERT INTO Customers (firstName, lastName, email, phone, membershipId)
        VALUES (p_firstName, p_lastName, p_email, p_phone, p_membershipId);

    COMMIT;

END //
DELIMITER ;