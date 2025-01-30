# Bakeey
---------
Overview 
---------
Bakeey is an application for all aspiring bakers to browse, book, and manage baking courses. Bakeey communicates perfectly with an Airtable API for data manipulation: course data, bookings, and user profiles.

---------------
Implementation
---------------
Bakeey is based on the MVVM Architecture, which helps to keep things neat and tidy. The logic behind this application is separated from the UI, thus making the code clean for updates.

----------------
Key Features:
--------------
Login System: User has to log in with email and password already stored in the API.
Course Management: User is able to see all courses, see course details, and book a class.
Bookings section: displays upcoming courses and allows the user to cancel if need be.
Edit Profile: The user can edit their name, and it gets updated in the API in real-time.

-----------
Methodology
-----------
The application was developed step by step according to the Agile methodology for the smoothness of the whole process.
Sprint-based Development:Every feature was built and checked before moving on with the others.
Unit Testing: API calls were tested for correctness regarding data returns.
User-Centric UI: Designed to be easy and intuitive to use.

---------------------------------
API Integration & CRUD Operations
---------------------------------
CREATE (POST) - Book Course
Whenever a user books a baking course, the application sends a POST request to the API. That puts the booking in Airtable and instantly updates the UI of that change.
{
  "fields": {
    "course_id": "course123",
    "user_id": "user456",
    "status": "Pending"
  }
}
Functionality:
The booking appears instantly in the Upcoming section.

--------------------------
Read (GET) – Fetching Data
--------------------------
The app often makes GET requests to the API for: course listing, user bookings, chef details.
Courses List: GET /course
User Bookings: GET /booking?filterByFormula={user_id}='currentUser'
Home screen (Upcoming Courses & Popular Courses)

--------------------------------------
Delete (DELETE) – Cancelling a Booking
--------------------------------------
A user may cancel a course, and then the app will delete the booking from the API and update the UI accordingly.
Endpoint: DELETE /booking/{id}
What happens?
The course disappears from the Upcoming section.
The record is removed permanently from the API.


App used:
POSTMAN 
XCODE 
