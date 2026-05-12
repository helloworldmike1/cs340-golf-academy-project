// ########################################
// ########## SETUP
require("dotenv").config();

// Express
const express = require("express");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));

const PORT = process.env.PORT;

// Database
const db = require("./database/db-connector");

const path = require("path");
console.log(
  "Resolved connector path:",
  require.resolve("./database/db-connector"),
);
console.log("DB object:", db);
console.log("DB typeof query:", typeof db.query);

// Handlebars
const { engine } = require("express-handlebars"); // Import express-handlebars engine
app.engine(".hbs", engine({ extname: ".hbs" })); // Create instance of handlebars
app.set("view engine", ".hbs"); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get("/", async function (req, res) {
  try {
    res.render("home");
  } catch (error) {
    console.error("Error rendering home page:", error);
    res.status(500).send("An error occurred while rendering the home page.");
  }
});

// Bays
app.get("/bays", async function (req, res) {
  try {
    // Create and execute our queries
    // In query1, select bays
    const query1 = "SELECT bayId, name, handedness, active FROM Bays;";
    const [bays] = await db.query(query1);

    // Render the bays.hbs file, and also send the renderer
    //  an object that contains our bays
    res.render("bays", { bays });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// Instructors
app.get("/instructors", async function (req, res) {
  try {
    // Create and execute our queries
    // In query1, select Instructors
    const query1 =
      "select instructorId, firstName, lastName,  email, phone, bio from Instructors ;";
    const [instructors] = await db.query(query1);

    // Render the Instructor.hbs file, and also send the renderer
    //  an object that contains our instructors
    res.render("instructors", { instructors: instructors });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// memberships
app.get("/memberships", async function (req, res) {
  try {
    // Create and execute our queries
    // In query1, select memberships
    const query1 =
      "select membershipId, name, price, offering from Memberships;";
    const [memberships] = await db.query(query1);

    // Render the Instructor.hbs file, and also send the renderer
    //  an object that contains our memberships
    res.render("memberships", { memberships: memberships });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// Customers
app.get("/customers", async function (req, res) {
  try {
    // Create and execute our queries
    // In query1, select customers
    const query1 =
      "Select C.customerId,  C.firstName, C.lastName, C.email, C.phone, M.name as membership from Customers C left join Memberships M on C.membershipId=M.membershipId ;";
    const [customers] = await db.query(query1);

    const query2 = "select membershipId, name from Memberships;";
    const [memberships] = await db.query(query2);

    // Render the Instructor.hbs file, and also send the renderer
    //  an object that contains our customers
    res.render("customers", { customers, memberships });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// Lessons // Participants
app.get("/lessons", async function (req, res) {
  try {
    // Create and execute our queries
    // In query1, select customers
  const query1 = `
SELECT
    l.lessonId,
    c.customerId,
    DATE_FORMAT(l.lessonTime, '%m/%d/%Y %h:%i %p') AS lessonTime,
    l.duration,
    CONCAT(i.firstName, ' ', i.lastName) AS instructor,
    b.name AS bay,
    ifnull( CONCAT(c.firstName, ' ', c.lastName) , 'Open') AS participant
FROM Lessons l
JOIN Instructors i
    ON l.instructorId = i.instructorId
JOIN Bays b
    ON l.bayId = b.bayId
LEFT JOIN LessonParticipants lp
    ON l.lessonId = lp.lessonId
LEFT JOIN Customers c
    ON lp.customerId = c.customerId
  ORDER BY   l.lessonId ASC;
`;
    const [lessons] = await db.query(query1);

    const query2 = "select lessonId, customerId  from LessonParticipants;";

    const [lessonparticipants] = await db.query(query2);

     const query3 =
      "select instructorId, firstName, lastName from Instructors ;";
    const [instructors] = await db.query(query3);

      const query4 = "SELECT bayId, name FROM Bays WHERE active='Y';";
    const [bays] = await db.query(query4);

        const query5 =
      "Select C.customerId,  C.firstName, C.lastName from Customers C ";
    const [customers] = await db.query(query5);



    // Render the Instructor.hbs file, and also send the renderer
    //  an object that contains our lessons
    res.render("lessons", { lessons, lessonparticipants, instructors, bays, customers  });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
  console.log(
    "Express started on http://localhost:" +
      PORT +
      "; press Ctrl-C to terminate.",
  );
});
