import Foundation

class LoginViewModel {
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        if username == "Akma" && password == "akosya.akmaral@gmail.com" {
            completion(true, nil)
        } else {
            completion(false, "Неправильный логин или пароль")
        }
    }
}
