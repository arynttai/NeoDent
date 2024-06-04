import UIKit

class HistoryViewController: UIViewController {

    private var appointments: [AppointmentDetail] = [] // This should be populated from persistent storage
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        loadAppointments()
    }
    
    private func loadAppointments() {
        // Load appointments from UserDefaults, database, or any persistent storage
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let appointment = appointments[indexPath.row]
        cell.textLabel?.text = "\(appointment.doctor.fullName) - \(appointment.appointment_time)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle appointment selection if needed
    }
}
