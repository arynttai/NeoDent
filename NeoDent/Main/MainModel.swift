import Foundation

struct Image: Codable {
    let id: Int
    let file: String
}

struct Service: Codable {
    let id: Int
    let name: String
    let image: Image
}

struct Specialization: Codable {
    let id: Int
    let name: String
}

struct Doctor: Codable {
    let id: Int
    let fullName: String
    let specialization: Specialization
    let workExperience: Int?
    let rating: Double?
    let workDays: String?
    let startWorkTime: String
    let endWorkTime: String
    let image: Image
    let isFavorite: Bool
}
