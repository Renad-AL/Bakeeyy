import Foundation

struct CourseResponse: Codable {
    let records: [CourseRecord]
}

struct CourseRecord: Codable {
    let id: String
    let fields: CourseFields
}

struct CourseFields: Codable {
    let id: String // Ensure this exists
    let title: String
    let level: String
    let location_name: String
    let location_latitude: Double
    let location_longitude: Double
    let chef_id: String
    let start_date: TimeInterval
    let end_date: TimeInterval
    let description: String
    let image_url: String
}

