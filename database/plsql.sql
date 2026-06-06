-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

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


-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

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


-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

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
    INSERT INTO Customers (firstName, lastName, email, phone, membershipId)
    VALUES (p_firstName, p_lastName, p_email, p_phone, p_membershipId);

END //
DELIMITER ;


-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

-- #############################
-- CREATE Lessons
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateLesson;

DELIMITER //
CREATE PROCEDURE sp_CreateLesson(
    IN p_lessonTime DATETIME,
    IN p_duration INT,
    IN p_instructorId INT,
    IN p_bayId INT
    )
BEGIN
    INSERT INTO Lessons (lessonTime, duration, instructorId, bayId)
    VALUES (p_lessonTime, p_duration, p_instructorId, p_bayId);


END //
DELIMITER ;


-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

-- #############################
-- CREATE Lesson Participants
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateLessonParticipant;

DELIMITER //
CREATE PROCEDURE sp_CreateLessonParticipant(
    IN p_lessonId INT,
    IN p_customerId INT
    )
BEGIN
    INSERT INTO LessonParticipants (lessonId, customerId)
    VALUES (p_lessonId, p_customerId);


END //
DELIMITER ;


-- Citation for the following function:
-- Date: 05/25/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: No AI tools were used in the creation of this procedure.

-- #############################
-- DELETE Lesson Participants
-- #############################

DROP PROCEDURE IF EXISTS sp_DeleteLessonParticipant;




DELIMITER //
CREATE PROCEDURE sp_DeleteLessonParticipant(IN p_lessonId INT, IN p_customerId INT)
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

        DELETE FROM LessonParticipants WHERE lessonId = p_lessonId and customerId = p_customerId;


        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in LessonParticipants for Lesson id: ',
            p_lessonId,
            ' Customer id: ',
            p_customerId);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


-- Citation for the following function:
-- Date: 06/06/2026
-- Copied from /OR/ Adapted from /OR/ Based on: adapted from the starter code
-- Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205
-- AI Tools: Procedure was written manually. AI was sparingly used to verify testing of the procedure.

-- #############################
-- UPDATE Lesson Participant
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateLessonParticipant;

DELIMITER //
CREATE PROCEDURE sp_UpdateLessonParticipant(
    IN p_previousLessonId INT,
    IN p_customerId       INT,
    IN p_newLessonId      INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

        UPDATE LessonParticipants
        SET lessonId = p_newLessonId
        WHERE lessonId = p_previousLessonId AND customerId = p_customerId;

    COMMIT;

END //
DELIMITER ;


