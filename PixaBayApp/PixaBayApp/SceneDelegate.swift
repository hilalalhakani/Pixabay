//
//  SceneDelegate.swift
//  PixaBayApp
//
//  Created by Hilal Hakkani on 19/02/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	var coordinator: MainCoordinator?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		if let windowScene = scene as? UIWindowScene {
			window = UIWindow(windowScene: windowScene)
			configureWindow()
		}
	}

	func configureWindow()
	{
		coordinator = MainCoordinator(window: window!, navigationController: UINavigationController())
		coordinator?.start()
	}
}
