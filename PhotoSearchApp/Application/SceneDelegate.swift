//
//  SceneDelegate.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        if let navigationController = window?.rootViewController as? UINavigationController, let searchViewcontroller = navigationController.topViewController as? SearchViewController {
            let moduleBuilder = ModuleBuilder()
                moduleBuilder.configureSearchViewController(viewController: searchViewcontroller)
        }
    }

}

