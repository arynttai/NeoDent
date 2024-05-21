import UIKit
import SnapKit

class MainViewController: UIViewController {

    private var viewModel = MainViewModel()
    
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
        label.text = "Привет, Акмарал! 👋"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var clinicServicesLabel: UILabel = {
        let label = UILabel()
        label.text = "Услуги клиники"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var moreServicesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Еще", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var servicesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var recommendedDoctorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Рекомендуемые докторы"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var moreDoctorsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Еще", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var doctorsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(greetingLabel)
        contentView.addSubview(clinicServicesLabel)
        contentView.addSubview(moreServicesButton)
        contentView.addSubview(servicesStackView)
        contentView.addSubview(recommendedDoctorsLabel)
        contentView.addSubview(moreDoctorsButton)
        contentView.addSubview(doctorsStackView)
        
        setupConstraints()
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
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        clinicServicesLabel.snp.makeConstraints { make in
            make.top.equalTo(greetingLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        moreServicesButton.snp.makeConstraints { make in
            make.centerY.equalTo(clinicServicesLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        servicesStackView.snp.makeConstraints { make in
            make.top.equalTo(clinicServicesLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        recommendedDoctorsLabel.snp.makeConstraints { make in
            make.top.equalTo(servicesStackView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
        }
        
        moreDoctorsButton.snp.makeConstraints { make in
            make.centerY.equalTo(recommendedDoctorsLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        doctorsStackView.snp.makeConstraints { make in
            make.top.equalTo(recommendedDoctorsLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func bindViewModel() {
        viewModel.onServicesUpdate = { [weak self] in
            guard let self = self else { return }
            self.updateServices()
        }
        
        viewModel.onDoctorsUpdate = { [weak self] in
            guard let self = self else { return }
            self.updateDoctors()
        }
        
        viewModel.onError = { [weak self] error in
            guard let self = self else { return }
            self.showError(error)
        }
    }
    
    private func updateServices() {
        servicesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for service in viewModel.services {
            let label = UILabel()
            label.text = service.name
            servicesStackView.addArrangedSubview(label)
        }
    }
    
    private func updateDoctors() {
        doctorsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for doctor in viewModel.doctors {
            let label = UILabel()
            label.text = "\(doctor.fullName) - \(doctor.specialization.name)"
            doctorsStackView.addArrangedSubview(label)
        }
    }
    
    private func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
