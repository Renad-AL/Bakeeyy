# Bakeey
---------
Overview 
---------
Bakeey is an application for all aspiring bakers to browse, book, and manage baking courses. Bakeey communicates perfectly with an Airtable API for data manipulation: course data, bookings, and user profiles.

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
