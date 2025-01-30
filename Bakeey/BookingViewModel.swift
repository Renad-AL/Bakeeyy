import Foundation

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingRecord] = []
    @Published var bookedCourses: [CourseFields] = [] // ✅ Stores booked courses
    @Published var popularCourses: [CourseFields] = [] // ✅ Stores all courses
    
    let apiURL = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/booking"
    let courseAPI = "https://api.airtable.com/v0/appXMW3ZsAddTpClm/course"
    let apiKey = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"
    
    // ✅ Fetch user bookings
    func fetchBookings(for userID: String, completion: @escaping () -> Void = {}) {
        guard let url = URL(string: "\(apiURL)?filterByFormula=%7Buser_id%7D='\(userID)'") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(BookingResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.bookings = decodedData.records
                        print("✅ Bookings Fetched: \(self.bookings.count)")
                        
                        // 🔥 Debug: Print all bookings
                        for booking in self.bookings {
                            print("📌 Booking - Course ID: \(booking.fields.course_id), User ID: \(booking.fields.user_id)")
                        }
                        
                        self.fetchBookedCourses(completion: completion) // ✅ Ensure courses are fetched after bookings
                    }
                } catch {
                    print("❌ Booking Decoding Error:", error)
                }
            } else if let error = error {
                print("❌ Error fetching bookings:", error.localizedDescription)
            }
        }.resume()
    }
    
    // ✅ Fetch full course details
    func fetchBookedCourses(completion: @escaping () -> Void = {}) {
        // 🔎 Get all booked course IDs
        let bookedCourseIDs = bookings.map { "\"\($0.fields.course_id)\"" }
        
        // 🔥 Ensure we only fetch courses that are booked
        let filterFormula = "OR(" + bookedCourseIDs.joined(separator: ",") + ")"
        let filteredCourseAPI = "\(courseAPI)?filterByFormula=\(filterFormula)"

        guard let url = URL(string: filteredCourseAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("❌ Invalid URL for fetching booked courses")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedCourses = try JSONDecoder().decode(CourseResponse.self, from: data)
                    DispatchQueue.main.async {
                        print("✅ Filtered Courses Fetched: \(decodedCourses.records.count)")

                        // 🔎 Debug - Print courses fetched
                        for course in decodedCourses.records {
                            print("📌 Course ID: \(course.id), Title: \(course.fields.title)")
                        }

                        // ✅ Now only store the booked courses
                        self.bookedCourses = decodedCourses.records.map { $0.fields }

                        print("✅ Final booked courses count: \(self.bookedCourses.count)")
                        completion()
                    }
                } catch {
                    print("❌ Error decoding booked courses:", error)
                }
            } else if let error = error {
                print("❌ Error fetching booked courses:", error.localizedDescription)
            }
        }.resume()
    }

    
    // ✅ Create booking & ensure booked courses appear instantly
    func createBooking(courseID: String, userID: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: apiURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "course_id": courseID,
                "user_id": userID,
                "status": "Pending"
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Error creating JSON body:", error)
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(BookingRecord.self, from: data)
                    DispatchQueue.main.async {
                        self.bookings.append(decodedResponse)
                        print("✅ Booking Created - Course ID: \(decodedResponse.fields.course_id)")
                        
                        // 🔄 Fetch updated bookings first, then refresh booked courses
                        self.fetchBookings(for: userID) {
                            print("🔄 Fetching updated bookings after creating a new one...")
                            self.fetchBookedCourses {
                                print("✅ Updated booked courses after booking!")
                                completion(true) // ✅ Now UI will update correctly
                            }
                        }
                    }
                } catch {
                    print("❌ Error decoding booking response:", error)
                    completion(false)
                }
            } else if let error = error {
                print("❌ Booking API error:", error.localizedDescription)
                completion(false)
            }
        }.resume()
    }
    func deleteBooking(bookingID: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(apiURL)/\(bookingID)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error deleting booking:", error.localizedDescription)
                } else {
                    print("✅ Booking deleted successfully!")

                    // Remove booking locally
                    self.bookings.removeAll { $0.id == bookingID }
                    self.fetchBookedCourses() // Refresh booked courses

                    completion()
                }
            }
        }.resume()
    }
    // ✅ Retrieves course details based on the course ID in the booking
    func getCourseDetails(for courseID: String) -> CourseFields? {
        return bookedCourses.first { $0.id == courseID }
    }

}
