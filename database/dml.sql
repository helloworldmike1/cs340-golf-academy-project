
-- get all Customers query 
SELECT C.customerID,  C.firstName, C.lastName, C.email, C.phone, C. membershipId FROM Customers;

-- query to get customer membership name drop down
SELECT membershipId, name FROM Memberships;

-- get memberships query
SELECT membershipId, name, price, offering FROM Memberships;

-- get all instructors query

SELECT instructorId, firstName,lastName, email, phone, bio FROM Instructors;

-- get all Bays query
SELECT bayId, name, handedness, active FROM Bays; 

-- select from lessons
SELECT lessonId, lessonTime, duration, instructorId, bayId FROM Lessons;

-- select from Lesson Participant 
SELECT lessonId, customerId FROM LessonParticipants;

-- Update to Bays 
UPDATE Bays 
SET NAME=:update_bay_name, 
    handedness = :update_bay_handedness 
    active = :update_bay_active
    WHERE bayId = :update_bay_id;

-- Delete a bay
Delete FROM Bays WHERE BayId = delete_bay_id;

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














