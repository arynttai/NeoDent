import UIKit
import SnapKit

class CalendarViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите дату и время"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let calendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    
    private let timeSlots: [String] = ["9:00", "11:30", "10:45", "13:20", "15:00", "16:30"]
    private var selectedTimeSlot: String?
    
    private let timeSlotStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(calendar)
        view.addSubview(timeSlotStackView)
        view.addSubview(continueButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        timeSlotStackView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
        
        setupTimeSlots()
    }
    
    private func setupTimeSlots() {
        for time in timeSlots {
            let button = UIButton(type: .system)
            button.setTitle(time, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(didSelectTimeSlot(_:)), for: .touchUpInside)
            timeSlotStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func didSelectTimeSlot(_ sender: UIButton) {
        for case let button as UIButton in timeSlotStackView.arrangedSubviews {
            button.backgroundColor = .clear
            button.setTitleColor(.systemBlue, for: .normal)
        }
        sender.backgroundColor = .systemBlue
        sender.setTitleColor(.white, for: .normal)
        selectedTimeSlot = sender.title(for: .normal)
    }
    
    @objc private func didTapContinueButton() {
        let confirmationVC = ConfirmationViewController()
        navigationController?.pushViewController(confirmationVC, animated: true)
    }
}
