import UIKit
import SnapKit

struct FilterOptions {
    var specialization: Specialization?
    var minExperience: Int?
    var maxExperience: Int?
    var minRating: Double?
    var maxRating: Double?
}

class FilterViewController: UIViewController {
    
    var doctors: [Doctor] = []
    private var specializations: [Specialization] = []
    var selectedFilters: ((FilterOptions) -> Void)?
    private var filters = FilterOptions()
    
    private lazy var specializationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        return picker
    }()
    
    private lazy var minExperienceTextField: UITextField = {
        let textField = createTextField(placeholder: "Минимальный стаж")
        textField.keyboardType = .numberPad
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    private lazy var maxExperienceTextField: UITextField = {
        let textField = createTextField(placeholder: "Максимальный стаж")
        textField.keyboardType = .numberPad
        textField.tag = 2
        textField.delegate = self
        return textField
    }()
    
    private lazy var minRatingTextField: UITextField = {
        let textField = createTextField(placeholder: "Минимальный рейтинг")
        textField.keyboardType = .decimalPad
        textField.tag = 3
        textField.delegate = self
        return textField
    }()
    
    private lazy var maxRatingTextField: UITextField = {
        let textField = createTextField(placeholder: "Максимальный рейтинг")
        textField.keyboardType = .decimalPad
        textField.tag = 4
        textField.delegate = self
        return textField
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Применить", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        extractSpecializations()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            createLabel(text: "Специализация"),
            specializationPicker,
            createLabel(text: "Минимальный стаж"),
            minExperienceTextField,
            createLabel(text: "Максимальный стаж"),
            maxExperienceTextField,
            createLabel(text: "Минимальный рейтинг"),
            minRatingTextField,
            createLabel(text: "Максимальный рейтинг"),
            maxRatingTextField,
            applyButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func extractSpecializations() {
        var uniqueSpecializations = Set<Specialization>()
        
        for doctor in doctors {
            uniqueSpecializations.insert(doctor.specialization)
        }
        
        specializations = Array(uniqueSpecializations)
        specializationPicker.reloadAllComponents()
    }
    
    @objc private func applyFilters() {
        selectedFilters?(filters)
        dismiss(animated: true, completion: nil)
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        return textField
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specializations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return specializations[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filters.specialization = specializations[row]
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        switch textField.tag {
        case 1:
            filters.minExperience = Int(text)
        case 2:
            filters.maxExperience = Int(text)
        case 3:
            filters.minRating = Double(text)
        case 4:
            filters.maxRating = Double(text)
        default:
            break
        }
    }
}
