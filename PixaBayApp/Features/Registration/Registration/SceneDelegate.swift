//
//  SceneDelegate.swift
//  Registration
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import UIKit
import RegistrationPresentation
import RegistrationNetwork
import SharedUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		let vc = LoginViewController.instantiate { coder in
			return LoginViewController(loginViewModel: LoginViewModel(userRepository: UserRepositoryMock()), coder: coder)
		}
		self.window = UIWindow(windowScene: scene)
		self.window?.rootViewController = UINavigationController(rootViewController: vc)

		window?.makeKeyAndVisible()
	}
}
