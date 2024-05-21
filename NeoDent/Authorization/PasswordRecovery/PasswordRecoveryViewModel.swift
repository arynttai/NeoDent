import UIKit

class PasswordRecoveryViewModel {
    
    private var login: String = ""
    private var email: String = ""
    
    var isFormValid: ((Bool) -> Void)?
    var errorMessage: ((String) -> Void)?
    var recoverySuccess: ((String) -> Void)?
    
    func updateLogin(_ login: String) {
        self.login = login
        validateForm()
    }
    
    func updateEmail(_ email: String) {
        self.email = email
        validateForm()
    }
    
    private func validateForm() {
        let isValid = !login.isEmpty && email.contains("@") && email.contains(".")
        isFormValid?(isValid)
    }
    
    func recoverPassword(completion: @escaping (Bool, String?) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.login == "Akma" && self.email == "akosya.akmaral@gmail.com" {
                self.recoverySuccess?(self.email)
                completion(true, nil)
            } else {
                completion(false, "Неверный логин или почта")
            }
        }
    }
}
