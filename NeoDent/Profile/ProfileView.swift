import UIKit
import Alamofire
import SnapKit

class ProfileViewController: UIViewController {
    
    var profile: Profile?
    var appointments: [AppointmentDetail] = []
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Профиль 🦷"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Редактировать профиль", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapEditProfileButton), for: .touchUpInside)
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        return button
    }()
    
    private let upcomingAppointmentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои предстоящие приемы"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let appointmentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: AppointmentCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        appointmentsTableView.delegate = self
        appointmentsTableView.dataSource = self
        
        setupLayout()
        fetchProfileData()
        loadAppointments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadAppointments), name: .appointmentSavedNotification, object: nil)
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(editProfileButton)
        view.addSubview(logoutButton)
        view.addSubview(upcomingAppointmentsLabel)
        view.addSubview(appointmentsTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        upcomingAppointmentsLabel.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        appointmentsTableView.snp.makeConstraints { make in
            make.top.equalTo(upcomingAppointmentsLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    func fetchProfileData() {
        let url = "https://neobook.online/neodent/users/profile/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, headers: headers).responseDecodable(of: Profile.self) { response in
            switch response.result {
            case .success(let profile):
                self.profile = profile
                self.nameLabel.text = "\(profile.firstName ?? "") \(profile.lastName ?? "")"
                self.usernameLabel.text = profile.username
                self.phoneNumberLabel.text = profile.phoneNumber
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileData()
    }
    
    @objc private func loadAppointments() {
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
            appointmentsTableView.reloadData()
        }
    }
    
    @objc private func didTapEditProfileButton() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.profile = profile
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc private func didTapLogoutButton() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentCell.identifier, for: indexPath) as? AppointmentCell else {
            return UITableViewCell()
        }
        let appointment = appointments[indexPath.row]
        cell.configure(with: appointment, accessToken: accessToken)
        cell.delegate = self
        return cell
    }
}

extension ProfileViewController: AppointmentCellDelegate {
    func didCancelAppointment(_ appointment: AppointmentDetail) {
        // Update local data and reload the table view
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments.remove(at: index)
            appointmentsTableView.reloadData()
            
            // Update UserDefaults
            let appointmentDicts = appointments.map { appointment in
                return [
                    "id": appointment.id,
                    "doctor": appointment.doctor.fullName,
                    "service": appointment.service.image,
                    "appointment_time": appointment.appointment_time,
                    "patient_first_name": appointment.patient_first_name,
                    "patient_last_name": appointment.patient_last_name,
                    "patient_phone_number": appointment.patient_phone_number,
                    "address": appointment.address,
                    "status": appointment.status
                ] as [String : Any]
            }
            UserDefaults.standard.setValue(appointmentDicts, forKey: "appointments")
            
            // Post a notification about the cancellation
            NotificationCenter.default.post(name: .appointmentCancelledNotification, object: appointment)
        }
    }
}

protocol AppointmentCellDelegate: AnyObject {
    func didCancelAppointment(_ appointment: AppointmentDetail)
}

class AppointmentCell: UITableViewCell {
    
    static let identifier = "AppointmentCell"
    weak var delegate: AppointmentCellDelegate?
    private var appointment: AppointmentDetail?
    private var accessToken: String?
    
    private let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let serviceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить запись", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(doctorNameLabel)
        contentView.addSubview(serviceLabel)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(cancelButton)
        
        doctorNameLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        serviceLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorNameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(serviceLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with appointment: AppointmentDetail, accessToken: String) {
        self.appointment = appointment
        self.accessToken = accessToken
        doctorNameLabel.text = appointment.doctor.fullName
        serviceLabel.text = appointment.service.image
        dateTimeLabel.text = appointment.appointment_time
        addressLabel.text = appointment.address
    }
    
    @objc private func didTapCancelButton() {
        guard let appointment = appointment, let accessToken = accessToken else { return }
        
        let url = "https://neobook.online/neodent/appointments/\(appointment.id)/cancel"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                self.delegate?.didCancelAppointment(appointment)
            case .failure(let error):
                print("Failed to cancel appointment: \(error)")
            }
        }
    }
}

extension Notification.Name {
    static let appointmentCancelledNotification = Notification.Name("appointmentCancelledNotification")
}
