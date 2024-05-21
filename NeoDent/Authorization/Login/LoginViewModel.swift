import Foundation

class LoginViewModel {
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        if username == "Vortex" && password == "CyberNova789" {
            completion(true, nil)
        } else {
            completion(false, "Неправильный логин или пароль")
        }
    }
}
