//Citation for the following function:
// Date: 05/25/2026
//Copied from /OR/ Adapted from /OR/ Based on: copied inital setup & selects of app.js from this exporlation.
// Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-web-application-technology-2?module_item_id=26640188

//Citation for the following function:
// Date: 05/25/2026
//Copied from /OR/ Adapted from /OR/ Based on: copied from the starter code for CRUD routes
// Source URL: https://canvas.oregonstate.edu/courses/2042369/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=26640205



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
// Home page
app.get("/", function (req, res) {
  res.render("home");
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
    res.render("lessons", {
      lessons,
      lessonparticipants,
      instructors,
      bays,
      customers,
    });
  } catch (error) {
    console.error("Error executing queries:", error);
    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// Reset Database
app.post("/reset-db", async function (req, res) {
  try {
    await db.query("CALL sp_resetdatabase();");

    res.redirect("/");
  } catch (error) {
    console.error("Error resetting database:", error);

    res.status(500).send("An error occurred while resetting the database.");
  }
});

// DELETE ROUTES
//Delete bays

app.post("/delete-bay", async function (req, res) {
  try {
    // Parse frontend form information
    let data = req.body;

    // Create and execute our query
    // Using parameterized queries (Prevents SQL injection attacks)
    const query1 = `CALL sp_DeleteBay(?);`;
    await db.query(query1, [data.delete_bay_id]);

    console.log(`DELETE bays. ID: ${data.delete_bay_id} `);

    // Redirect the user to the updated webpage data
    res.redirect("/bays");
  } catch (error) {
    console.error(error);

    if (error.errno === 1451) {
      return res
        .status(400)
        .send("Cannot delete bay. Currently holding lessons.");
    }

    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});





// DELETE LessonParticipant
app.post('/delete-lesson-participant', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute our query
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_DeleteLessonParticipant(?,?);`;
        await db.query(query1, [data.lessonId, data.participant]);

        console.log(`DELETE Lesson ID: ${data.lessonId} ` +
            `Customer ID: ${data.participant}`
        );

        // Redirect the user to the updated webpage data
        res.redirect('/lessons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// UPDATE ROUTES
// Update Bay
app.post("/update-bay", async function (req, res) {
  try {
    // Parse frontend form information
    let data = req.body;

    // Convert empty/unselected fields to NULL so sp_UpdateBay preserves existing values
    // Using parameterized queries (Prevents SQL injection attacks)
    const name =
      data.update_bay_name && data.update_bay_name.trim()
        ? data.update_bay_name.trim()
        : null;
    const handedness = data.update_bay_handedness || null;
    const active = data.update_bay_active || null;

    if (name === null && handedness === null && active === null) {
      return res.redirect("/bays");
    }

    const query1 = `CALL sp_UpdateBay(?, ?, ?, ?)`;
    await db.query(query1, [data.update_bay_id, name, handedness, active]);

    console.log(`UPDATE bay. ID: ${data.update_bay_id}`);

    // Redirect the user to the updated webpage data
    res.redirect("/bays");
  } catch (error) {
    console.error(error);

    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// CREATE ROUTES
// Create Customer
app.post("/create-customer", async function (req, res) {
  try {
    // Parse frontend form information
    let data = req.body;

    // Normalize membership selection: empty or 'NULL' string becomes SQL NULL
    const membershipRaw =
      data[":membershipId_from_create_customer_membership_dropdown"];
    const membershipId =
      membershipRaw === "NULL" || membershipRaw === "" || membershipRaw == null
        ? null
        : membershipRaw;

    // Create and execute our query
    // Using parameterized queries (Prevents SQL injection attacks)
    const query1 = `CALL sp_CreateCustomer(?, ?, ?, ?, ?);`;
    await db.query(query1, [
      data.create_customer_firstName,
      data.create_customer_lastName,
      data.create_customer_email,
      data.create_customer_phone,
      membershipId,
    ]);

    console.log(
      `CREATE customer: ${data.create_customer_firstName} ${data.create_customer_lastName}`,
    );

    // Redirect the user to the updated webpage data
    res.redirect("/customers");
  } catch (error) {
    console.error(error);

    // Send a generic error message to the browser
    res
      .status(500)
      .send("An error occurred while executing the database queries.");
  }
});

// CREATE Lesson
app.post('/add-lesson', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

      
        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateLesson(?, ?, ?, ?);`;

        // 
         await db.query(query1, [
            data.create_lesson_time,
            data.create_lesson_duration,
            data.instructorId_from_add_lesson,
            data.bayId_from_add_lesson
        ]);

        console.log(`CREATE Lesson: ${data.create_lesson_time} ` +
            `Duration: ${data.create_lesson_duration} `+
             `Instructor:${data.instructorId_from_add_lesson}` +
             `Bay:${data.bayId_from_add_lesson}` 
        );

        // Redirect the user to the updated webpage
        res.redirect('/lessons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});





// CREATE LessonParticipant
app.post('/add-lesson-participant', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

      
        // Create and execute our queries
        // Using parameterized queries (Prevents SQL injection attacks)
        const query1 = `CALL sp_CreateLessonParticipant(?, ?);`;

        // 
         await db.query(query1, [
            data.add_lessonid_to_participants_dropdown,
            data.add_customerid_to_participants_dropdown
           
        ]);

        console.log(`CREATE Customer ID: ${data.add_customerid_to_participants_dropdown} ` +
            `Lesson Id ID: ${data.add_lessonid_to_participants_dropdown} `
            
        );

        // Redirect the user to the updated webpage
        res.redirect('/lessons');
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
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
