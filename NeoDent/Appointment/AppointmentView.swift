import UIKit
import Alamofire
import SnapKit

class AppointmentViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Запись на прием 🗓"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let doctorLabel: UILabel = {
        let label = UILabel()
        label.text = "Доктор"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let doctorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выберите врача", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapDoctorButton), for: .touchUpInside)
        return button
    }()
    
    private let doctorArrow: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapDoctorButton), for: .touchUpInside)
        return button
    }()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата и время"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let dateTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выберите дату и время", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapDateTimeButton), for: .touchUpInside)
        return button
    }()
    
    private let dateTimeArrow: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapDateTimeButton), for: .touchUpInside)
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private var selectedDoctor: Doctor? {
        didSet {
            guard let doctor = selectedDoctor else { return }
            doctorButton.setTitle(doctor.fullName, for: .normal)
            updateContinueButtonState()
        }
    }
    
    private var selectedDate: Date?
    private var selectedTime: String?
    private var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(doctorLabel)
        view.addSubview(doctorButton)
        view.addSubview(doctorArrow)
        view.addSubview(dateTimeLabel)
        view.addSubview(dateTimeButton)
        view.addSubview(dateTimeArrow)
        view.addSubview(continueButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        doctorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        doctorButton.snp.makeConstraints { make in
            make.top.equalTo(doctorLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(doctorArrow.snp.leading).offset(-8)
            make.height.equalTo(44)
        }
        
        doctorArrow.snp.makeConstraints { make in
            make.centerY.equalTo(doctorButton)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        dateTimeButton.snp.makeConstraints { make in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(dateTimeArrow.snp.leading).offset(-8)
            make.height.equalTo(44)
        }
        
        dateTimeArrow.snp.makeConstraints { make in
            make.centerY.equalTo(dateTimeButton)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    @objc private func didTapDoctorButton() {
        let doctorsListVC = DoctorsListViewController()
        doctorsListVC.delegate = self
        navigationController?.pushViewController(doctorsListVC, animated: true)
    }
    
    @objc private func didTapDateTimeButton() {
        guard let selectedDoctor = selectedDoctor else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, выберите врача", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let calendarVC = CalendarViewController(doctor: selectedDoctor, accessToken: accessToken)
        calendarVC.delegate = self
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc private func didTapContinueButton() {
        guard let doctor = selectedDoctor, let date = selectedDate, let time = selectedTime else { return }
        let personalDetailsVC = PersonalDetailsViewController(doctor: doctor, date: date, time: time, accessToken: accessToken)
        navigationController?.pushViewController(personalDetailsVC, animated: true)
    }
    
    private func updateContinueButtonState() {
        if selectedDoctor != nil && selectedDate != nil && selectedTime != nil {
            continueButton.isEnabled = true
            continueButton.backgroundColor = .systemBlue
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        }
    }
}

extension AppointmentViewController: DoctorsListViewControllerDelegate {
    func didSelectDoctor(_ doctor: Doctor) {
        self.selectedDoctor = doctor
    }
}

extension AppointmentViewController: CalendarViewControllerDelegate {
    func didSelectDate(_ date: Date, time: String) {
        self.selectedDate = date
        self.selectedTime = time
        dateTimeButton.setTitle("\(date) \(time)", for: .normal)
        updateContinueButtonState()
    }
}
