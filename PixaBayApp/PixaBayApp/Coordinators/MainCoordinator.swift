import Foundation
import UIKit
import RegistrationNetwork
import RegistrationPresentation

class MainCoordinator: Coordinator {
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController
	var window: UIWindow

	init(window: UIWindow, navigationController: UINavigationController) {
		self.navigationController = navigationController
		self.window = window

		window.rootViewController = navigationController
		window.makeKeyAndVisible()
	}

	func start() {
		let loginCoordinator = LoginCoordinator(parentCoordinator: self, navigationController: navigationController)
		loginCoordinator.start()
		self.childCoordinators.append(loginCoordinator)
	}

	func navigateToHome() {
		self.childCoordinators.removeAll()
		self.navigationController.viewControllers.removeAll()

		let homeCoordinator = HomeCoordinator(parentCoordinator: self, navigationController: navigationController)
		childCoordinators.append(homeCoordinator)
		window.rootViewController = navigationController
		homeCoordinator.start()
		UIView.transition(with: window,
		                  duration: 0.3,
		                  options: .transitionCrossDissolve,
		                  animations: nil,
		                  completion: nil)
	}
}
