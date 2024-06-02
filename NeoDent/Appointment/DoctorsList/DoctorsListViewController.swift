import UIKit
import SnapKit
import Kingfisher

class DoctorsListViewController: UIViewController {
    
    private var viewModel = MainViewModel()
    private var filteredDoctors: [Doctor] = []
    private var isSearching = false
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Я ищу..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createCompositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DoctorCollectionViewCell.self, forCellWithReuseIdentifier: DoctorCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupUI()
        fetchDoctors()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(filterButton)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(filterButton.snp.left).offset(-10)
        }
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.right.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createDoctorsSection()
        }
    }
    
    private func createDoctorsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        return section
    }
    
    private func fetchDoctors() {
        viewModel.fetchDoctors {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func handleFavoriteAction(for doctor: Doctor) {
        if let index = viewModel.doctors.firstIndex(where: { $0.id == doctor.id }) {
            viewModel.doctors[index].isFavorite.toggle()
            if isSearching {
                if let searchIndex = filteredDoctors.firstIndex(where: { $0.id == doctor.id }) {
                    filteredDoctors[searchIndex].isFavorite.toggle()
                }
            }
            collectionView.reloadData()
        }
    }
    
    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.doctors = viewModel.doctors
        filterVC.selectedFilters = { [weak self] filters in
            self?.applyFilters(filters)
        }
        present(filterVC, animated: true, completion: nil)
    }
    
    private func applyFilters(_ filters: FilterOptions) {
        var filtered = viewModel.doctors
        
        if let specialization = filters.specialization {
            filtered = filtered.filter { $0.specialization.id == specialization.id }
        }
        
        if let minExperience = filters.minExperience {
            filtered = filtered.filter { $0.workExperience >= minExperience }
        }
        
        if let maxExperience = filters.maxExperience {
            filtered = filtered.filter { $0.workExperience <= maxExperience }
        }
        
        if let minRating = filters.minRating {
            filtered = filtered.filter { ($0.rating ?? 0) >= minRating }
        }
        
        if let maxRating = filters.maxRating {
            filtered = filtered.filter { ($0.rating ?? 0) <= maxRating }
        }
        
        isSearching = true
        filteredDoctors = filtered
        collectionView.reloadData()
    }
}

extension DoctorsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredDoctors.count : viewModel.doctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorCollectionViewCell.identifier, for: indexPath) as! DoctorCollectionViewCell
        let doctor = isSearching ? filteredDoctors[indexPath.row] : viewModel.doctors[indexPath.row]
        cell.configure(with: doctor)
        cell.favoriteAction = { [weak self] in
            self?.handleFavoriteAction(for: doctor)
        }
        return cell
    }
}

extension DoctorsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredDoctors = []
        } else {
            isSearching = true
            filteredDoctors = viewModel.doctors.filter { $0.fullName.lowercased().contains(searchText.lowercased()) || $0.specialization.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        filteredDoctors = []
        collectionView.reloadData()
    }
}
