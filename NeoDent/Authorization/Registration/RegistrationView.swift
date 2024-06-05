import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
    private var viewModel = RegistrationViewModel()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация ✍️"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите ваше имя"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Фамилия"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите вашу фамилию"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Придумайте уникальный логин"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Почта"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Укажите почту в формате example@mail.ru"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+7 ___ ___ __ __"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Придумайте пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.rightView = makeEyeButton()
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.rightView = makeEyeButton()
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([
            greetingLabel,
            firstNameLabel, firstNameTextField,
            lastNameLabel, lastNameTextField,
            usernameLabel, usernameTextField,
            emailLabel, emailTextField,
            phoneNumberLabel, phoneNumberTextField,
            passwordLabel, passwordTextField,
            confirmPasswordLabel, confirmPasswordTextField,
            registerButton
        ])
        
        setupConstraints()
        addTextFieldTargets()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func makeEyeButton() -> UIButton {
        let button = UIButton(type: .custom)
        let eyeClosedImage = UIImage(systemName: "eye.slash")
        let eyeOpenImage = UIImage(systemName: "eye")
        button.setImage(eyeClosedImage, for: .normal)
        button.setImage(eyeOpenImage, for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }
    
    private func addTextFieldTargets() {
        [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, phoneNumberTextField, passwordTextField, confirmPasswordTextField].forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == firstNameTextField {
            viewModel.updateFirstName(textField.text ?? "")
        } else if textField == lastNameTextField {
            viewModel.updateLastName(textField.text ?? "")
        } else if textField == usernameTextField {
            viewModel.updateUsername(textField.text ?? "")
        } else if textField == emailTextField {
            viewModel.updateEmail(textField.text ?? "")
        } else if textField == phoneNumberTextField {
            viewModel.updatePhoneNumber(textField.text ?? "")
        } else if textField == passwordTextField {
            viewModel.updatePassword(textField.text ?? "")
        } else if textField == confirmPasswordTextField {
            viewModel.updateConfirmPassword(textField.text ?? "")
        }
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender == passwordTextField.rightView {
            passwordTextField.isSecureTextEntry.toggle()
        } else if sender == confirmPasswordTextField.rightView {
            confirmPasswordTextField.isSecureTextEntry.toggle()
        }
    }
    
    private func bindViewModel() {
        viewModel.isFormValid = { [weak self] isValid in
            DispatchQueue.main.async {
                self?.registerButton.isEnabled = isValid
                self?.registerButton.backgroundColor = isValid ? .blue : .lightGray
            }
        }
        
        viewModel.errorMessage = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.userFound = { [weak self] userId in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Пользователь найден", message: "Пользователь с таким номером телефона уже существует. Пожалуйста, войдите в систему.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.userCreated = { [weak self] userId in
            DispatchQueue.main.async {
                print("Registration Successful")
                let verificationVC = VerificationViewController()
                self?.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
    
    @objc private func registerTapped() {
        viewModel.registerUser { [weak self] success, errorMessage in
            DispatchQueue.main.async {
                if !success, let errorMessage = errorMessage {
                    self?.viewModel.errorMessage?(errorMessage)
                } else {
                    if let username = self?.usernameTextField.text, let accessToken = self?.viewModel.accessToken {
                        let mainTabBarController = MainTabBarController(username: username, accessToken: accessToken)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self?.present(mainTabBarController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
