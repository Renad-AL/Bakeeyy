import Foundation

struct UserResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String
    let fields: UserFields
}

struct UserFields: Codable {
    let id: String?
    let name: String
    let email: String
    let password: String
}

