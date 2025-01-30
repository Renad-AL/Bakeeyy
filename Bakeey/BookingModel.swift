import Foundation

// Model for a single booking record
struct BookingRecord: Codable, Identifiable {
    let id: String
    let fields: BookingFields
}

// Fields inside each booking record
struct BookingFields: Codable {
    let course_id: String
    let user_id: String
    let status: String
}

// API Response Wrapper for Bookings
struct BookingResponse: Codable {
    let records: [BookingRecord]
}
