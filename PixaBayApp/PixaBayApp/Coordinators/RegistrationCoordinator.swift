//
//  RegistrationCoordinator.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import UIKit
import RxSwift
import RegistrationNetwork
import RegistrationPresentation
import Resolver
import SharedUI

class LoginCoordinator: Coordinator
{
	//MARK: Injected
	private weak var parentCoordinator: MainCoordinator?
	private var window: UIWindow

	//MARK: Coordinator Properties
	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController

	//MARK: Properties
	let diposeBag = DisposeBag()

	init(parentCoordinator: MainCoordinator, navigationController: UINavigationController) {
		self.window = parentCoordinator.window
		self.parentCoordinator = parentCoordinator
		self.navigationController = navigationController
	}
}

extension LoginCoordinator: ReactiveCompatible {
	func setupNavigationBar() {
		self.navigationController.navigationBar.tintColor = .white
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .purple
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		self.navigationController.navigationBar.standardAppearance = appearance
		self.navigationController.navigationBar.scrollEdgeAppearance = appearance
	}

	func start() {
		let loginViewController = LoginViewController.instantiate { coder -> LoginViewController in
			let userRepository: UserRepository = Resolver.resolve()
			let loginViewModel = LoginViewModel(userRepository: userRepository)
			return LoginViewController(loginViewModel: loginViewModel, coder: coder)!
		}

		loginViewController.rx.navigateToHome
			.drive(self.rx.navigateToHome)
			.disposed(by: self.diposeBag)

		loginViewController.rx.navigateToRegistration
			.drive(self.rx.navigateToRegistration)
			.disposed(by: self.diposeBag)

		self.navigationController.pushViewController(loginViewController, animated: false)
		self.setupNavigationBar()
	}

	func navigateToRegistration() {
		let registrationViewController = RegistrationViewController.instantiate { coder -> RegistrationViewController in
			let userRepository: UserRepository = Resolver.resolve()
			let viewModel = RegistrationViewModel(userRepository: userRepository)
			return RegistrationViewController(coder: coder, viewModel: viewModel)!
		}

		registrationViewController.rx.navigateToHome
			.drive(self.rx.navigateToHome)
			.disposed(by: self.diposeBag)

		self.navigationController.pushViewController(registrationViewController, animated: true)
	}

	func navigateToHome() {
		self.parentCoordinator?.navigateToHome()
	}
}

extension Reactive where Base: LoginCoordinator
{
	var navigateToRegistration: Binder<Void> {
		Binder(self.base) { component, _ in
			component.navigateToRegistration()
		}
	}

	var navigateToHome: Binder<Void> {
		Binder(self.base) { component, _ in
			component.navigateToHome()
		}
	}
}
