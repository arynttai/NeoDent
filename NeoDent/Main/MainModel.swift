import Foundation

struct Service {
//    let name: String
    let image: String
}

struct Doctor: Codable {
    let id: Int
    let fullName: String
    let specialization: Specialization
    let workExperience: Int
    let rating: Double?
    let workDays: [String]
    let startWorkTime: String
    let endWorkTime: String
    let image: Image
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case specialization
        case workExperience = "work_experience"
        case rating
        case workDays = "work_days"
        case startWorkTime = "start_work_time"
        case endWorkTime = "end_work_time"
        case image
        case isFavorite = "is_favorite"
    }
}

struct Specialization: Codable {
    let id: Int
    let name: String
}

struct Image: Codable {
    let id: Int
    let file: String
}

struct DoctorsResponse: Codable {
    let totalCount: Int
    let totalPages: Int
    let list: [Doctor]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case totalPages = "total_pages"
        case list
    }
}
