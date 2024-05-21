import UIKit
import SnapKit

class PasswordRecoveryViewController: UIViewController {
    
    private var viewModel = PasswordRecoveryViewModel()
    
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
        label.text = "Восстановление пароля 🔒"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = createTextField(placeholder: "Введите ваш логин")
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
        let textField = createTextField(placeholder: "Введите вашу почту")
        return textField
    }()
    
    private lazy var proceedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
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
        
        contentView.addSubview(greetingLabel)
        contentView.addSubview(loginLabel)
        contentView.addSubview(loginTextField)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(proceedButton)
        
        setupConstraints()
        addTextFieldTargets()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        greetingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        proceedButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }
    
    private func addTextFieldTargets() {
        loginTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.updateLogin(loginTextField.text ?? "")
        viewModel.updateEmail(emailTextField.text ?? "")
    }
    
    private func bindViewModel() {
        viewModel.isFormValid = { [weak self] isValid in
            DispatchQueue.main.async {
                self?.proceedButton.isEnabled = isValid
                self?.proceedButton.backgroundColor = isValid ? .blue : .gray
            }
        }
        
        viewModel.errorMessage = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        viewModel.recoverySuccess = { [weak self] email in
            DispatchQueue.main.async {
                let message = "На вашу почту \(email) было отправлено письмо с кодом для восстановления пароля. Пожалуйста, введите полученный код ниже."
                let alert = UIAlertController(title: "Письмо отправлено", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    let verificationVC = VerificationCodeViewController()
                    self?.navigationController?.pushViewController(verificationVC, animated: true)
                })
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc private func proceedTapped() {
        viewModel.recoverPassword { [weak self] success, errorMessage in
            if !success, let errorMessage = errorMessage {
                self?.viewModel.errorMessage?(errorMessage)
            }
        }
    }
}

// ViewModel для PasswordRecoveryViewController

class PasswordRecoveryViewModel {
    
    private var login: String = ""
    private var email: String = ""
    
    var isFormValid: ((Bool) -> Void)?
    var errorMessage: ((String) -> Void)?
    var recoverySuccess: ((String) -> Void)?
    
    func updateLogin(_ login: String) {
        self.login = login
        validateForm()
    }
    
    func updateEmail(_ email: String) {
        self.email = email
        validateForm()
    }
    
    private func validateForm() {
        let isValid = !login.isEmpty && email.contains("@") && email.contains(".")
        isFormValid?(isValid)
    }
    
    func recoverPassword(completion: @escaping (Bool, String?) -> Void) {
        // Здесь должен быть код для запроса к серверу на отправку кода восстановления пароля
        // Пример успешного ответа:
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.login == "correctLogin" && self.email == "correct@example.com" {
                self.recoverySuccess?(self.email)
                completion(true, nil)
            } else {
                completion(false, "Неверный логин или почта")
            }
        }
    }
}

// Контроллер для ввода кода восстановления пароля (VerificationCodeViewController)

class VerificationCodeViewController: UIViewController {
    // Реализация экрана ввода кода
}
