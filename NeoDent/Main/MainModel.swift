import Foundation

struct Service: Codable {
    let image: String
}

struct Doctor: Codable {
    let id: Int
    var fullName: String
    var specialization: Specialization
    var workExperience: Int
    var rating: Double?
    var workDays: [String]
    var startWorkTime: String
    var endWorkTime: String
    var image: Image
    var isFavorite: Bool
    
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

struct Specialization: Codable, Hashable {
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

struct TimeSlot: Codable {
    let time_slot: String
}

struct AppointmentDetail: Codable {
    let id: String
    let doctor: Doctor
    let service: Service
    let appointment_time: String
    let patient_first_name: String
    let patient_last_name: String
    let patient_phone_number: String
    let address: String
    let status: String
}
