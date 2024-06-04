import UIKit
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
        button.isEnabled = false // Initially disabled
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    private var selectedDoctor: Doctor? {
        didSet {
            guard let doctor = selectedDoctor else { return }
            doctorButton.setTitle(doctor.fullName, for: .normal)
            continueButton.isEnabled = true // Enable the button once a doctor is selected
            continueButton.backgroundColor = .systemBlue // Change the button color to indicate it's enabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false) // Показываем навигационный бар
        setupLayout()
    }
    
    private func setupLayout() {
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(doctorLabel)
        view.addSubview(doctorButton)
        view.addSubview(doctorArrow)
        view.addSubview(dateTimeLabel)
        view.addSubview(dateTimeButton)
        view.addSubview(dateTimeArrow)
        view.addSubview(continueButton)
        
        // Setup constraints
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
        let calendarVC = CalendarViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc private func didTapContinueButton() {
        let confirmationVC = ConfirmationViewController()
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
}

extension AppointmentViewController: DoctorsListViewControllerDelegate {
    func didSelectDoctor(_ doctor: Doctor) {
        self.selectedDoctor = doctor
    }
}
