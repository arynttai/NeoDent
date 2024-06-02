import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private var viewModel = LoginViewModel()

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Приветствуем! 👋"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .red
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.isHidden = true
        return label
    }()

    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Логин"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите ваш логин"
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
        textField.placeholder = "Введите ваш пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        let eyeClosedImage = UIImage(systemName: "eye.slash")
        let eyeOpenImage = UIImage(systemName: "eye")
        button.setImage(eyeClosedImage, for: .normal)
        button.setImage(eyeOpenImage, for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()

    private lazy var registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Впервые у нас?"
        label.textAlignment = .center
        return label
    }()

    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupBindings()
    }

    private func setupUI() {
        view.addSubview(greetingLabel)
        view.addSubview(errorLabel)
        view.addSubview(loginLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(eyeButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(registerLabel)
        view.addSubview(registerButton)
    }

    private func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(175)
            make.left.right.equalToSuperview().inset(20)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        eyeButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField.snp.right).inset(10)
            make.width.height.equalTo(30)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(600)
            make.centerX.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            self.errorLabel.isHidden = true
            // Navigate to MainTabBarController or perform other actions
            if let username = self.usernameTextField.text {
                let mainTabBarController = MainTabBarController(username: username)
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.navigationController?.setViewControllers([mainTabBarController], animated: true)
            }
        }
        
        viewModel.onLoginFailure = { [weak self] errorMessage in
            guard let self = self else { return }
            self.errorLabel.text = errorMessage
            self.errorLabel.isHidden = false
        }
    }

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }

    @objc private func didTapLoginButton() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            errorLabel.text = "Пожалуйста, заполните все поля."
            errorLabel.isHidden = false
            return
        }

        let loginModel = LoginModel(username: username, password: password)
        viewModel.login(with: loginModel)
    }

    @objc private func forgotPasswordTapped() {
        let recoveryVC = PasswordRecoveryViewController()
        navigationController?.pushViewController(recoveryVC, animated: true)
    }

    @objc private func registerTapped() {
        let registrationVC = RegistrationViewController()
        navigationController?.pushViewController(registrationVC, animated: true)
    }
}
