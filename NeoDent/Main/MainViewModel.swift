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
        
        AF.request(url).responseData { response in
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
}
