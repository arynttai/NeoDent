import Foundation

class RegistrationViewModel {
    private var user = RegistrationModel(first_name: nil, last_name: nil, username: "", email: nil, phone_number: "", password: "", confirm_password: "")
    
    var isFormValid: ((Bool) -> Void)?
    var errorMessage: ((String) -> Void)?
    var userFound: ((Int) -> Void)?
    var userCreated: ((Int) -> Void)?
    
    func updateFirstName(_ firstName: String) {
        user.first_name = firstName
        validateForm()
    }
    
    func updateLastName(_ lastName: String) {
        user.last_name = lastName
        validateForm()
    }
    
    func updateUsername(_ username: String) {
        user.username = username
        validateForm()
    }
    
    func updateEmail(_ email: String) {
        user.email = email
        validateForm()
    }
    
    func updatePhoneNumber(_ phoneNumber: String) {
        user.phone_number = phoneNumber
        validateForm()
    }
    
    func updatePassword(_ password: String) {
        user.password = password
        validateForm()
    }
    
    func updateConfirmPassword(_ confirmPassword: String) {
        user.confirm_password = confirmPassword
        validateForm()
    }
    
    private func validateForm() {
        let isValid = !(user.username.isEmpty || user.phone_number.isEmpty || user.password.isEmpty || user.confirm_password.isEmpty) && user.password == user.confirm_password
        isFormValid?(isValid)
    }
    
    func registerUser(completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://neobook.online/neodent/users/register/") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let registrationRequest = RegistrationRequest(
            username: user.username,
            phone_number: user.phone_number,
            password: user.password,
            confirm_password: user.confirm_password,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
        )
        
        guard let jsonData = try? JSONEncoder().encode(registrationRequest) else {
            completion(false, "Failed to encode JSON")
            return
        }
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON data being sent: \(jsonString)")
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false, "No data received")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Error response: \(responseString)")
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = jsonResponse["message"] as? String {
                        if message == "User found" {
                            if let userId = jsonResponse["user_id"] as? Int {
                                DispatchQueue.main.async {
                                    self.userFound?(userId)
                                }
                            }
                        } else if message == "User has successfully created" {
                            if let userId = jsonResponse["user_id"] as? Int {
                                DispatchQueue.main.async {
                                    self.userCreated?(userId)
                                }
                            }
                        } else {
                            completion(false, message)
                        }
                    } else {
                        completion(true, nil)
                    }
                } else {
                    completion(false, "Invalid JSON format")
                }
            } catch {
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
