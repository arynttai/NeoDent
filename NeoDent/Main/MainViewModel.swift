import Foundation
import Alamofire

class MainViewModel {
    var services: [Service] = [
        Service(image: "filling"),
        Service(image: "cleaning"),
        Service(image: "crown"),
        Service(image: "implantation"),
        Service(image: "rootСanals"),
        Service(image: "whitening")
    ]
    
    var doctors: [Doctor] = []
    
    func fetchDoctors(completion: @escaping () -> Void) {
        let url = "https://neobook.online/neodent/doctors/"
        
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("No access token found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(DoctorsResponse.self, from: data)
                    self.doctors = decodedResponse.list
                    completion()
                } catch {
                    print("Failed to decode doctors: \(error)")
                }
            case .failure(let error):
                print("Failed to fetch doctors: \(error)")
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = "https://neobook.online/neodent/users/login/"
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], let accessToken = json["access"] as? String {
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        completion(true)
    }
}
