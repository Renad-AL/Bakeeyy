import Foundation

struct CourseDetailResponse: Codable {
    let records: [CourseDetailRecord]
}

struct CourseDetailRecord: Codable {
    let id: String
    let fields: CourseDetailFields
}

struct CourseDetailFields: Codable, Equatable {
    let id: String
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
    
    // Custom Equatable Implementation (Swift can auto-generate this)
    static func == (lhs: CourseDetailFields, rhs: CourseDetailFields) -> Bool {
        return lhs.id == rhs.id
    }
}

