import UIKit

class MainTabBarController: UITabBarController {

    private var username: String
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = MainViewController(username: username)
        homeVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let appointmentVC = UINavigationController(rootViewController: AppointmentViewController())
        appointmentVC.tabBarItem = UITabBarItem(title: "Запись на прием", image: UIImage(systemName: "calendar"), tag: 1)
        
        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        historyVC.tabBarItem = UITabBarItem(title: "История записей", image: UIImage(systemName: "clock.fill"), tag: 2)
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle.fill"), tag: 3)
        
        let tabBarList = [homeVC, appointmentVC, historyVC, profileVC]
        
        viewControllers = tabBarList
    }
}
