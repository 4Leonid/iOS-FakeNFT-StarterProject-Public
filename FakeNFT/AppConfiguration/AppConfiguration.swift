//
//  AppConfiguration.swift
//  FakeNFT
//
//  Created by Леонид Турко on 05.04.2024.
//

import UIKit

final class AppConfiguration {
  let catalogViewController: UIViewController
  let profileViewController: UIViewController
  var servicesAssembly: ServicesAssembly!
  private let catalogNavigationController: UINavigationController
  private let cartService: CartControllerProtocol
  
  init() {
    profileViewController = ProfileViewController(servicesAssembly: servicesAssembly)
    
    let dataProvider = CatalogDataProvider(networkClient: DefaultNetworkClient())
    let router = CatalogRouter()
    
    let catalogPresenter = CatalogPresenter(dataProvider: dataProvider, router: router)
    cartService = CartService()
    
    let catalogViewController = CatalogViewController(presenter: catalogPresenter, cartService: cartService)
    self.catalogViewController = catalogViewController
    catalogPresenter.viewController = catalogViewController
    catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
    router.viewController = catalogViewController
  }
}
