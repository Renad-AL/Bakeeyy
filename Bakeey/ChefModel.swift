import Foundation

struct ChefResponse: Codable {
    let records: [ChefRecord]
}

struct ChefRecord: Codable {
    let id: String
    let fields: ChefFields
}

struct ChefFields: Codable {
    let id: String
    let name: String
    let email: String
}
