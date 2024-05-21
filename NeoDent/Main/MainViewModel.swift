import Foundation
import Alamofire

class MainViewModel {
    
    var services: [Service] = []
    var doctors: [Doctor] = []
    
    var onServicesUpdate: (() -> Void)?
    var onDoctorsUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchData() {
        let login = "Vortex"
        let password = "CyberNova789"
        let credentials = Data("\(login):\(password)".utf8).base64EncodedString()
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(credentials)"
        ]
        
        
        AF.request("https://neobook.online/neodent/swagger/", headers: headers).responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseDict = try decoder.decode([String: [Service]].self, from: data)
                    if let services = responseDict["services"] {
                        self?.services = services
                        self?.onServicesUpdate?()
                    }
                    let responseDictForDoctors = try decoder.decode([String: [Doctor]].self, from: data)
                    if let doctors = responseDictForDoctors["doctors"] {
                        self?.doctors = doctors
                        self?.onDoctorsUpdate?()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    self?.onError?("Failed to parse data")
                }
            case .failure(let error):
                print(error)
                self?.onError?("Failed to fetch data")
            }
        }
    }
}
