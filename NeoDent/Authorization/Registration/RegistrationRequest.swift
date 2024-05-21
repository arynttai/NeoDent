import Foundation

struct RegistrationRequest: Codable {
    let username: String
    let phone_number: String
    let password: String
    let confirm_password: String
    let first_name: String?
    let last_name: String?
    let email: String?
}
