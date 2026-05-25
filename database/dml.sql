-- Citation for the following function:
-- Date: 05/25/2026
--Source: format pulled from Canvas lecture. Other wise written manually. AI was promted to help convert into the correct date format was wanting

-- original get all Customers query 
SELECT C.customerID,  C.firstName, C.lastName, C.email, C.phone, C.membershipId FROM Customers;


--- new customers query with the membershipname instead of the id
Select C.customerId,  C.firstName, C.lastName, C.email, C.phone, M.name as membership from Customers C left join Memberships M on C.membershipId=M.membershipId;

-- query to get customer membership name drop down
SELECT membershipId, name FROM Memberships;

-- get memberships query
SELECT membershipId, name, price, offering FROM Memberships;

-- get all instructors query

SELECT instructorId, firstName,lastName, email, phone, bio FROM Instructors;

-- get all Bays query
SELECT bayId, name, handedness, active FROM Bays; 

-- original select implemented from lessons
SELECT lessonId, lessonTime, duration, instructorId, bayId FROM Lessons;

--- more info joined with bay id and instructorid and formatting the date better
SELECT
    l.lessonId,
     c.customerId,
    DATE_FORMAT(l.lessonTime, '%m/%d/%Y %h:%i %p') AS lessonTime,
    l.duration,
    CONCAT(i.firstName, ' ', i.lastName) AS instructor,
    b.name AS bay,
    ifnull( CONCAT(c.firstName, ' ', c.lastName),'Open') AS participant
FROM Lessons l
JOIN Instructors i
    ON l.instructorId = i.instructorId
JOIN Bays b
    ON l.bayId = b.bayId
LEFT JOIN LessonParticipants lp
    ON l.lessonId = lp.lessonId
LEFT JOIN Customers c
    ON lp.customerId = c.customerId
ORDER BY l.lessonId ASC;

-- select from Lesson Participant 
SELECT lessonId, customerId FROM LessonParticipants;

-- Update to Bays 
UPDATE Bays 
SET NAME=:update_bay_name, 
    handedness = :update_bay_handedness ,
    active = :update_bay_active
    WHERE bayId = :update_bay_id;

-- Delete a bay
Delete FROM Bays WHERE BayId = :delete_bay_id;

-- Create New a new customer in customers table
-- membershipId will be from drop down
INSERT INTO Customers (firstName, lastName, email, phone, membershipId) 
VALUES 
( 
    :create_customer_firstName, 
    :create_customer_lastName, 
    :create_customer_email, 
    :create_customer_phone, 
    :membershipId_from_create_customer_membership_dropdown
);


-- Add a new lesson in Lesson table
-- instructorId will be from drop down
-- bayId will be from drop down

INSERT INTO Lessons (lessonTime, duration, instructorId, bayId)
VALUES ( :create_lesson_time, 
         :create_lesson_duration, 
         :instructorId_from_add_lesson, 
         :bayId_from_add_lesson 
);

-- for Instructor drop down list
SELECT instructorId, firstName, lastName FROM Instructors ;

-- For Bay Drop down list
SELECT bayId, name FROM Bays WHERE active='Y';

INSERT INTO LessonParticipants (customerId, lessonId) 
VALUES ( :add_customerid_to_participants_dropdown, 
         :add_lessonid_to_participants_dropdown
);   


--- delete customer from lessonparticipant 
DELETE FROM LessonParticipants WHERE lessonId=:lessonId and customerId=:CustomerId; 



--- UPDATE lesson Participant 
UPDATE LessonParticipants 
SET lessonId = :updated_lessonId
WHERE lessonId = :previous_lessonId 
and CustomerId = :customerId; 










