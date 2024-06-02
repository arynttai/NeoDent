import UIKit
import SnapKit

class DoctorDetailViewController: UIViewController {
    
    var doctor: Doctor
     
     init(doctor: Doctor) {
         self.doctor = doctor
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let specializationLabel = UILabel()
    private let experienceLabel = UILabel()
    private let workDaysLabel = UILabel()
    private let ratingLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(specializationLabel)
        view.addSubview(experienceLabel)
        view.addSubview(workDaysLabel)
        view.addSubview(ratingLabel)
        view.addSubview(favoriteButton)
        view.addSubview(nextButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        specializationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        experienceLabel.snp.makeConstraints { make in
            make.top.equalTo(specializationLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        workDaysLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(workDaysLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
    
    private func configureUI() {
        nameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specialization.name
        experienceLabel.text = "Стаж: \(doctor.workExperience) лет"
        workDaysLabel.text = "График работы: \(doctor.workDays.joined(separator: ", "))"
        ratingLabel.text = "Рейтинг: \(doctor.rating ?? 0.0)"
        
        if let url = URL(string: doctor.image.file) {
            imageView.kf.setImage(with: url)
        }
        
        favoriteButton.setImage(UIImage(systemName: doctor.isFavorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.tintColor = .red
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        nextButton.setTitle("Далее", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func toggleFavorite() {
        doctor.isFavorite.toggle()
        favoriteButton.setImage(UIImage(systemName: doctor.isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
    
    @objc private func didTapNextButton() {
        let calendarVC = CalendarViewController()
        navigationController?.pushViewController(calendarVC, animated: true)
    }
}
