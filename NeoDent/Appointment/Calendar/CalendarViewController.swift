import UIKit
import SnapKit
import Alamofire

protocol CalendarViewControllerDelegate: AnyObject {
    func didSelectDate(_ date: Date, time: String)
}

class CalendarViewController: UIViewController {
    
    weak var delegate: CalendarViewControllerDelegate?
    
    var doctor: Doctor?
    var accessToken: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3NTM3Nzg1LCJpYXQiOjE3MTc1MzQxODUsImp0aSI6ImIxYTMyMGUyMGQ0NDQxMDliOGFlZWM3ODBhNDVmMzRhIiwidXNlcl9pZCI6NDd9.EaWmScVI9qUqcxoZOk952h16Uo1xigHKFLxha8ghYRk"
    init(doctor: Doctor, accessToken: String?) {
        self.doctor = doctor
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите дату и время"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let calendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        return datePicker
    }()
    
    private var timeSlots: [String] = []
    private var selectedTimeSlot: String?
    
    private let timeSlotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        calendar.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(calendar)
        view.addSubview(timeSlotStackView)
        view.addSubview(continueButton)
        view.addSubview(errorLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        timeSlotStackView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(timeSlotStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func fetchTimeSlots(for date: Date) {
        guard let doctor = doctor, let token = accessToken else {
            print("Доктор или токен не выбран")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let url = "https://neobook.online/neodent/doctors/\(doctor.id)/hours/?date=\(dateString)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Server response: \(data)")
                if let json = data as? [[String: Any]] {
                    self.timeSlots = json.compactMap { $0["time_slot"] as? String }
                    if self.timeSlots.isEmpty {
                        self.showError("Врач не работает в выбранную дату.")
                    } else {
                        self.errorLabel.isHidden = true
                        self.continueButton.isEnabled = true
                        self.updateTimeSlotButtons()
                    }
                } else {
                    self.showError("Врач не работает в выбранную дату.")
                }
            case .failure(let error):
                if let statusCode = response.response?.statusCode, statusCode == 401 {
                    self.refreshAccessToken {
                        self.fetchTimeSlots(for: date)
                    }
                } else {
                    print("Ошибка при получении временных слотов: \(error)")
                    self.showError("Ошибка при получении временных слотов.")
                }
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping () -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else {
            print("No refresh token found")
            return
        }
        
        let url = "https://neobook.online/neodent/users/login/refresh/"
        let parameters: [String: Any] = [
            "refresh": refreshToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], let newAccessToken = json["access"] as? String {
                    UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                    completion()
                } else {
                    print("Failed to refresh token: \(data)")
                }
            case .failure(let error):
                print("Error refreshing token: \(error)")
            }
        }
    }
    
    private func updateTimeSlotButtons() {
        timeSlotStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for time in timeSlots {
            let button = UIButton(type: .system)
            button.setTitle(time, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.addTarget(self, action: #selector(didSelectTimeSlot(_:)), for: .touchUpInside)
            timeSlotStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        fetchTimeSlots(for: sender.date)
    }
    
    @objc private func didSelectTimeSlot(_ sender: UIButton) {
        for case let button as UIButton in timeSlotStackView.arrangedSubviews {
            button.backgroundColor = .white
            button.setTitleColor(.systemBlue, for: .normal)
        }
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        selectedTimeSlot = sender.title(for: .normal)
    }
    
    @objc private func didTapContinueButton() {
        guard let selectedDate = calendar.date as Date?,
              let selectedTime = selectedTimeSlot else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, выберите дату и время", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        delegate?.didSelectDate(selectedDate, time: selectedTime)
        navigationController?.popViewController(animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        continueButton.isEnabled = false
        timeSlots.removeAll()
        updateTimeSlotButtons()
    }
}
