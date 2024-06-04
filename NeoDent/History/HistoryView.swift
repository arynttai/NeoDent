import UIKit

class HistoryViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var appointments: [AppointmentDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "История записей"
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        
        loadAppointments()
    }
    
    private func loadAppointments() {
        if let appointmentDicts = UserDefaults.standard.array(forKey: "appointments") as? [[String: Any]] {
            appointments = appointmentDicts.compactMap { dict in
                guard let id = dict["id"] as? String,
                      let doctorName = dict["doctor"] as? String,
                      let serviceImage = dict["service"] as? String,
                      let appointmentTime = dict["appointment_time"] as? String,
                      let firstName = dict["patient_first_name"] as? String,
                      let lastName = dict["patient_last_name"] as? String,
                      let phoneNumber = dict["patient_phone_number"] as? String,
                      let address = dict["address"] as? String,
                      let status = dict["status"] as? String else {
                    return nil
                }
                let doctor = Doctor(id: 1, fullName: doctorName, specialization: Specialization(id: 1, name: ""), workExperience: 10, rating: 4.5, workDays: [], startWorkTime: "", endWorkTime: "", image: Image(id: 1, file: ""), isFavorite: true)
                let service = Service(image: serviceImage)
                return AppointmentDetail(id: id, doctor: doctor, service: service, appointment_time: appointmentTime, patient_first_name: firstName, patient_last_name: lastName, patient_phone_number: phoneNumber, address: address, status: status)
            }
            tableView.reloadData()
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let appointment = appointments[indexPath.row]
        cell.textLabel?.text = "\(appointment.patient_first_name) \(appointment.patient_last_name) - \(appointment.appointment_time)"
        return cell
    }
}
