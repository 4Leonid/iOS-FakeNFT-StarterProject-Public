import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorage(),
        nftByIdStorage: NftByIdStorage()
    )
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    let appConfiguration = AppConfiguration()
    self.window = window
    
    window.rootViewController = TabBarController(appConfiguration: appConfiguration, servicesAssembly: servicesAssembly)
    window.makeKeyAndVisible()
  }
}
