import Foundation
import Alamofire

class LoginViewModel {
    var onLoginSuccess: ((String) -> Void)?
    var onLoginFailure: ((String) -> Void)?

    func login(with model: LoginModel) {
        let url = "https://neobook.online/neodent/users/login/"
        let parameters: [String: Any] = [
            "username": model.username,
            "password": model.password
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Server response: \(value)")
                if let json = value as? [String: Any], let accessToken = json["access"] as? String, let refreshToken = json["refresh"] as? String {
                    print("Access token: \(accessToken)")
                    self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                    self.onLoginSuccess?(accessToken)
                } else if let json = value as? [String: Any], let detail = json["detail"] as? String {
                    self.onLoginFailure?(detail)
                } else {
                    self.onLoginFailure?("Неизвестная ошибка")
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                self.onLoginFailure?(error.localizedDescription)
            }
        }
    }

    private func saveTokens(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
    }
}
