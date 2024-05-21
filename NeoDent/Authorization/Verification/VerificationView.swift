import UIKit
import VKPinCodeView
import SnapKit

class VerificationViewController: UIViewController {
    
    private var viewModel = VerificationViewModel()
    
    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Код подтверждения"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите код подтверждения, отправленный на ваш номер телефона."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pinView: VKPinCodeView = {
        let pinView = VKPinCodeView()
        pinView.keyBoardType = .numberPad
        pinView.onSettingStyle = { BorderStyle() }
        pinView.keyBoardAppearance = .dark
        pinView.becomeFirstResponder()
        pinView.onComplete = { [weak self] code, _ in
            self?.viewModel.updateCode(code)
        }
        return pinView
    }()
    
    private lazy var verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var resendCodeContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var resendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить код повторно", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.isEnabled = true
        button.addTarget(self, action: #selector(resendCodeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "*Код введен неверно"
        label.textAlignment = .left
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(greetingLabel)
        view.addSubview(infoLabel)
        view.addSubview(pinView)
        view.addSubview(verifyButton)
        view.addSubview(errorLabel)
        view.addSubview(resendCodeContainer)
        
        resendCodeContainer.addSubview(resendCodeButton)
        resendCodeContainer.addSubview(timerLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        pinView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(verifyButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        resendCodeContainer.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        resendCodeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(pinView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        viewModel.isButtonEnabled = { [weak self] isEnabled in
            DispatchQueue.main.async {
                self?.verifyButton.isEnabled = isEnabled
            }
        }
        
        viewModel.isErrorLabelHidden = { [weak self] isHidden in
            DispatchQueue.main.async {
                self?.errorLabel.isHidden = isHidden
            }
        }
        
        viewModel.timerUpdate = { [weak self] timeText in
            DispatchQueue.main.async {
                self?.timerLabel.text = timeText
                self?.timerLabel.isHidden = timeText.isEmpty
                self?.resendCodeButton.isHidden = !timeText.isEmpty
            }
        }
        
        viewModel.canResendCode = { [weak self] canResend in
            DispatchQueue.main.async {
                self?.resendCodeButton.isEnabled = canResend
                self?.resendCodeButton.setTitleColor(canResend ? .blue : .gray, for: .normal)
            }
        }
    }
    
    @objc private func verifyTapped() {
        viewModel.verifyCode()
    }
    
    @objc private func resendCodeTapped() {
        viewModel.resendCode()
    }
}
