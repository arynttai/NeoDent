import Foundation

struct RegistrationModel: Codable {
    var first_name: String?
    var last_name: String?
    var username: String
    var email: String?
    var phone_number: String
    var password: String
    var confirm_password: String
}
