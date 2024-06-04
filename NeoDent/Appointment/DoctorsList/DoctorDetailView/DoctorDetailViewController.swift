import UIKit
import SnapKit
import Kingfisher

protocol DoctorDetailViewControllerDelegate: AnyObject {
    func didSelectDoctor(_ doctor: Doctor)
}

class DoctorDetailViewController: UIViewController {

    private var doctor: Doctor
    weak var delegate: DoctorDetailViewControllerDelegate?

    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let doctorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let specializationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let workExperienceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let workDaysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let workTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configure()
    }

    private func setupUI() {
        view.addSubview(doctorImageView)
        view.addSubview(nameLabel)
        view.addSubview(specializationLabel)
        view.addSubview(workExperienceLabel)
        view.addSubview(ratingLabel)
        view.addSubview(workDaysLabel)
        view.addSubview(workTimeLabel)
        view.addSubview(favoriteButton)
        view.addSubview(nextButton)

        doctorImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(doctorImageView.snp.top)
            make.right.equalTo(doctorImageView.snp.right).offset(20)
            make.width.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        specializationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        let infoStack = UIStackView(arrangedSubviews: [workExperienceLabel, ratingLabel, workDaysLabel, workTimeLabel])
        infoStack.axis = .vertical
        infoStack.distribution = .equalSpacing
        infoStack.spacing = 10
        view.addSubview(infoStack)

        infoStack.snp.makeConstraints { make in
            make.top.equalTo(specializationLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    private func configure() {
        if let imageUrl = URL(string: doctor.image.file) {
            doctorImageView.kf.setImage(with: imageUrl)
        }
        nameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specialization.name
        workExperienceLabel.text = "Стаж: \(doctor.workExperience) лет"
        ratingLabel.text = "Рейтинг: \(doctor.rating ?? 0)"
        workDaysLabel.text = "Рабочие дни: \(doctor.workDays.joined(separator: ", "))"
        workTimeLabel.text = "Время: \(doctor.startWorkTime) - \(doctor.endWorkTime)"
        favoriteButton.setImage(UIImage(systemName: doctor.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }

    @objc private func toggleFavorite() {
        doctor.isFavorite.toggle()
        favoriteButton.setImage(UIImage(systemName: doctor.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }

    @objc private func nextButtonTapped() {
        delegate?.didSelectDoctor(doctor)
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers {
                if let appointmentVC = viewController as? AppointmentViewController {
                    navigationController.popToViewController(appointmentVC, animated: true)
                    break
                }
            }
        }
    }
}
