import UIKit
import Kingfisher
import SnapKit

class DoctorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DoctorCollectionViewCell"
    
    lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var doctorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    lazy var specializationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .systemYellow
        return label
    }()
    
    lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(doctorImage)
        cardView.addSubview(nameLabel)
        cardView.addSubview(specializationLabel)
        cardView.addSubview(experienceLabel)
        cardView.addSubview(ratingLabel)
        cardView.addSubview(workTimeLabel)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        doctorImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(doctorImage.snp.top)
            make.leading.equalTo(doctorImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        specializationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        experienceLabel.snp.makeConstraints { make in
            make.top.equalTo(specializationLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(experienceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        workTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with doctor: Doctor) {
        if let url = URL(string: doctor.image.file) {
            doctorImage.kf.setImage(with: url)
        } else {
            doctorImage.image = UIImage(systemName: "person.fill") // Placeholder image
        }
        nameLabel.text = doctor.fullName
        specializationLabel.text = doctor.specialization.name
        experienceLabel.text = "Стаж работы: \(doctor.workExperience) лет"
        if let rating = doctor.rating {
            ratingLabel.text = "Рейтинг: \(rating)"
        } else {
            ratingLabel.text = "Рейтинг: N/A"
        }
        let workDays = doctor.workDays.joined(separator: ", ")
        workTimeLabel.text = "Рабочие дни: \(workDays)\nВремя: \(doctor.startWorkTime) - \(doctor.endWorkTime)"
    }
}
