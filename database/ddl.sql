-- Michael Pearsall & Richard Hong
-- Group # 23

-- disable commits and foreign key checks at the beginning of your file
SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;



-- drop Membership table if it exists 
DROP TABLE IF EXISTS Memberships; 

-- create Memberships table
CREATE TABLE Memberships ( 
 membershipId int AUTO_INCREMENT UNIQUE NOT NULL, 
 name varchar (30) not null, 
 price decimal (12,2) not null, 
 offering varchar (140) not null, 
 primary key ( membershipId)
);

-- insert into Memberships to show the memberships available at the academy
INSERT INTO Memberships (name, price, offering) 
VALUES 
(
  'Pro Plan',
  300.00, 
  'Unlimited practice at the facility, a fee club fitting, a 20% discount on balls and gloves, and two lessons per month'
), 
(
  'Individual', 
  125.00, 
  'Unlimited practice at the facility, free-regripping, guest Fridays, 10% off balls, gloves and lesson packs, and One 30 min lesson a month'
), 
(
  'Junior Plan', 
  215.00, 
  'One 30-minute lesson each week, along with membership to the Academy'
);



-- drop Instructors table if it exists 
DROP TABLE IF EXISTS Instructors;

-- create Instructors table 
CREATE TABLE Instructors (
  instructorId int auto_increment unique not NULL ,
  firstName varchar(140) not null,
  lastName varchar(140) not null,
  email varchar(45) not null,
  phone varchar(45) not null,
  bio varchar(140) not null,
  primary key (instructorId)
);

-- insert into Instructors
INSERT INTO Instructors (firstName, lastName, email, phone, bio)
VALUES
( 
  'Tyler', 
  'Brooks', 
  'tbrooks@beavergolfacademy.com', 
  '832-943-4821',
  'PGA-certified coach specializing in swing mechanics. Helps players of all levels build consistency.'
),
( 
  'Lauren',
  'Mitchell', 
  'lmitchell@beavergolfacademy.com', 
  '281-641-6593',
  'Former college golfer at LSU. Focused on short game and fundamentals. Passionate about helping golfers enjoy the game.'
), 
( 
  'Marcus', 
  'Delgado', 
  'mdelgado@beavergolfacademy.com', 
  '832-651-2748',
  'Former mini-tour player with years of coaching experience. Focuses on course strategy and lowering scores.'
);



-- drop Bays table if it exists 
DROP TABLE IF EXISTS Bays;

-- create Bays table
CREATE TABLE Bays ( 
  bayId int auto_increment unique not NULL ,
  name varchar (30) not null,
  handedness varchar (10) not null ,
  active char (1) not null default 'Y',
  primary key (bayId)
);

--insert into Bays 
INSERT INTO Bays (name, handedness) 
VALUES 
(
  'Bay 1', 
  'RH'
), 
(
  'Bay 2', 
  'RH/LH'
),
(
  'Bay 3', 
  'RH/LH'
),
(
  'Bay 4', 
  'RH'
);


 -- drop Customers table if it exists 
DROP TABLE IF EXISTS Customers;

-- create Customers table
CREATE TABLE Customers ( 
 customerId int AUTO_INCREMENT UNIQUE NOT NULL ,
 firstName varchar (140) not null, 
 lastName varchar (140) not null, 
 email varchar (140) not null, 
 phone varchar (45) not null , 
 membershipId int ,
 primary key (customerId), 
 foreign key (membershipId) references Memberships(membershipId)
);

-- insert into Customers
INSERT INTO Customers 
( firstName, 
  lastName, 
  email, 
  phone, 
  membershipId
)
VALUES 
(
  'Jason', 
  'Turner', 
  'jason.turner92@gmail.com', 
  '832-946-2147',
  (SELECT membershipId FROM Memberships WHERE NAME ='Pro Plan') 
),
(
  'Emily', 
  'Carter', 
  'emily_carter88@yahoo.com', 
  '281-672-8932',
  (SELECT membershipId FROM Memberships WHERE NAME ='Pro Plan') 
),
(
  'Daniel', 
  'Nguyen', 
  'dnguyen1@gmail.com', 
  '713-418-4478',
  (SELECT membershipId FROM Memberships WHERE NAME ='Individual')
),
(
  'Sophia', 
  'Ramirez', 
  'sophieramirez21@gmail.com', 
  '832-731-6621',
  (SELECT membershipId FROM Memberships WHERE NAME ='Junior Plan') 
);


 -- drop Lesson table if it exists 
DROP TABLE IF EXISTS Lessons;

-- create Lessons Table
CREATE TABLE Lessons ( 
  lessonId int not null auto_increment primary key,
  lessonTime datetime not null,
  duration int not null,
  instructorId int not null ,
  bayId int not null ,
  foreign key (instructorId) references Instructors(instructorId),
  foreign key (bayId) references Bays(bayId)
);

-- insert into Lessons
INSERT INTO Lessons (lessonTime, duration, instructorId, bayId)
VALUES
( 
  '2026-04-27 09:00:00',
  30,
  (SELECT instructorId FROM Instructors WHERE  firstName = 'Lauren' AND lastName = 'Mitchell'),
  (SELECT bayId FROM Bays WEHRE NAME = 'Bay 1')
),
( 
  '2026-04-27 10:00:00',60,
  (SELECT instructorId FROM Instructors WHERE firstName = 'Lauren' AND lastName = 'Mitchell'),
  (SELECT bayId FROM Bays WHERE NAME = 'Bay 3')
), 
 (
  '2026-05-27 09:00:00',
  30,
  (SELECT instructorId FROM Instructors WHERE firstName = 'Marcus' AND lastName = 'Delgado'),
  (SELECT bayId FROM Bays WHERE NAME = 'Bay 2')
),
( 
  '2026-05-27 11:00:00',
  60,
  (SELECT instructorId FROM Instructors WHERE firstName = 'Tyler' AND lastName = 'Brooks'),
  (SELECT bayId FROM Bays WEHRE NAME = 'Bay 2')
);



 -- drop LessonParticipants table if it exists 
DROP TABLE IF EXISTS LessonParticipants;

--create LessonParticipants table
CREATE TABLE LessonParticipants ( 
  lessonId int not null, 
  customerId int not null,
  foreign key (lessonId ) references Lessons(lessonId) ON DELETE CASCADE,
  foreign key (customerId ) references Customers(customerId) ON DELETE CASCADE,
  primary key ( lessonId,customerId) 
);

-- insert into LessonParticipants
INSERT INTO LessonParticipants 
VALUES
( 
  (
    SELECT l.lessonId 
    FROM Lessons l 
    JOIN Instructors i ON l.instructorId = i.instructorId
    WHERE l.lessonTime='2026-04-27 09:00:00' AND i.firstName='Lauren' AND i.lastName= 'Mitchell'
  ), 
  (SELECT customerId FROM Customers WHERE firstName = 'Jason' AND lastName = 'Turner')
),
( 
  (
    SELECT l.lessonId 
    FROM Lessons l
    JOIN Instructors i ON l.instructorId = i.instructorId
    WHERE l.lessonTime='2026-04-27 09:00:00' AND i.firstName='Lauren' AND i.lastName= 'Mitchell'
  ), 
  (SELECT customerId FROM Customers WHERE firstName = 'Emily' AND lastName = 'Carter')
),
( 
  (
    SELECT l.lessonId 
    FROM Lessons l
    JOIN Instructors i ON l.instructorId = i.instructorId
    WHERE l.lessonTime='2026-05-27 09:00:00' AND i.firstName = 'Marcus' AND i.lastName = 'Delgado'
  ), 
  (SELECT customerId FROM Customers WHERE firstName ='Daniel' AND lastName = 'Nguyen')
),
( 
  (
    SELECT l.lessonId 
    FROM Lessons l
    JOIN Instructors i ON l.instructorId = i.instructorId
    WHERE l.lessonTime = '2026-05-27 11:00:00' AND i.firstName = 'Tyler' AND i.lastName = 'Brooks'
  ), 
  (SELECT customerId FROM Customers WHERE firstName = 'Sophia' AND lastName = 'Ramirez')
);



-- re-enable foreign key checks at the end to minimize import errors
SET FOREIGN_KEY_CHECKS=1;
COMMIT;