import Foundation

struct LoginResponse: Codable {
    let access: String
    let refresh: String
}
