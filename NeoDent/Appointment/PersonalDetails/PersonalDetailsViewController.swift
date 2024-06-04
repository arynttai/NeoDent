import UIKit
import SnapKit

class PersonalDetailsViewController: UIViewController {
    
    var doctor: Doctor?
    var date: Date?
    var time: String?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите ваши данные"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Имя"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Фамилия"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Записаться на прием", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(submitButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapSubmitButton() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let doctor = doctor, let date = date, let time = time else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, заполните все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let appointment = AppointmentDetail(
            id: UUID().uuidString,
            doctor: doctor,
            service: Service(image: "Service Image"),
            appointment_time: "\(date) \(time)",
            patient_first_name: firstName,
            patient_last_name: lastName,
            patient_phone_number: phone,
            address: "Address",
            status: "Scheduled"
        )
        saveAppointment(appointment)
        
        let confirmationVC = ConfirmationViewController()
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
    
    private func saveAppointment(_ appointment: AppointmentDetail) {
        // Implement saving appointment to UserDefaults, database, or any persistent storage
        
        var appointments = UserDefaults.standard.array(forKey: "appointments") as? [[String: Any]] ?? []
        
        let appointmentDict: [String: Any] = [
            "id": appointment.id,
            "doctor": appointment.doctor.fullName,
            "service": appointment.service.image,
            "appointment_time": appointment.appointment_time,
            "patient_first_name": appointment.patient_first_name,
            "patient_last_name": appointment.patient_last_name,
            "patient_phone_number": appointment.patient_phone_number,
            "address": appointment.address,
            "status": appointment.status
        ]
        
        appointments.append(appointmentDict)
        UserDefaults.standard.set(appointments, forKey: "appointments")
    }
}
