import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 1
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticController = StatisticViewController(servicesAssembly: servicesAssembly)
        let navigationStatisticController = UINavigationController(rootViewController: statisticController)
        statisticController.tabBarItem = statisticTabBarItem

        viewControllers = [navigationStatisticController]

        view.backgroundColor = .systemBackground
    }
}
