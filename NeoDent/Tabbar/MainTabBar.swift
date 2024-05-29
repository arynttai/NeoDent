import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = MainViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let appointmentVC = AppointmentViewController()
        appointmentVC.tabBarItem = UITabBarItem(title: "Запись на прием", image: UIImage(systemName: "calendar"), tag: 1)
        
        let historyVC = HistoryViewController()
        historyVC.tabBarItem = UITabBarItem(title: "История записей", image: UIImage(systemName: "clock.fill"), tag: 2)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle.fill"), tag: 3)
        
        let tabBarList = [homeVC, appointmentVC, historyVC, profileVC]
        
        viewControllers = tabBarList.map {
            UINavigationController(rootViewController: $0)
        }
    }
}
