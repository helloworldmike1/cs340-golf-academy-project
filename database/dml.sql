
-- get all Customers query 
Select C.customerID,  C.firstName, C.lastName, C.email, C.phone, C. membershipId 
from Customers ;

-- query to get customer membership name drop down
select membershipId,,name from Memberships;


-- get memberships query
select membershipId, name, price, offering from Memberships;


-- get all instructors query

select instructorId, firstName,lastName, email, phone, bio 
from Instructors ;

-- get all Bays query
select bayId, name, handedness, activefrom Bays; 

-- select from lessons
select lessonId, lessonTime, duration, instructorId, bayId from Lessons;

-- select from Lesson Participant 

select lessonId, customerId  from LessonParticipants;


-- Update to Bays 
update Bays 

set name=:update_bay_name, 
    handedness = :update_bay_handedness 
    active = :update_bay_active

    where bayId = :update_bay_id;


-- Delete a bay

Delete from Bays where BayId =delete_bay_id;


-- Create New a new customer in customers table
-- membershipId will be from drop down
Insert Into Customers (firstName, lastName, email, phone, membershipId) values 
( :create_customer_firstName, :create_customer_lastName, :create_customer_email, :create_customer_phone, :membershipId_from_create_customer_membership_dropdown
);














