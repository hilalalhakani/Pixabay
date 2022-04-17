//
//  HomeCoordinator.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import UIKit
import HomePresentation
import HomeNetwork
import Resolver
import RxSwift
import RxCocoa
import HomeDetailsPresentation
import Networking

class HomeCoordinator: Coordinator, ReactiveCompatible {
	private weak var parentCoordinator: MainCoordinator?
	private var window: UIWindow

	var childCoordinators = [Coordinator]()
	var navigationController: UINavigationController

	let diposeBag = DisposeBag()

	init(parentCoordinator: MainCoordinator, navigationController: UINavigationController) {
		self.window = parentCoordinator.window
		self.parentCoordinator = parentCoordinator
		self.navigationController = navigationController
		setupNavigationBar()
	}

	func setupNavigationBar() {
		navigationController.navigationBar.tintColor = .white
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .purple
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navigationController.navigationBar.standardAppearance = appearance
		navigationController.navigationBar.scrollEdgeAppearance = appearance
	}

	func start() {
		let homeViewController = HomeViewController.instantiate { coder -> HomeViewController in
			let pixabayRepository: PixaBayRepository = Resolver.resolve()
			let homeViewModel = HomeViewModel(pixaBayRepository: pixabayRepository, imageDownloader: Resolver.resolve())
			return HomeViewController(coder: coder, viewModel: homeViewModel)!
		}

		homeViewController.rx.navigateToImageDetails
			.drive(self.rx.navigateToImageDetails)
			.disposed(by: self.diposeBag)

		navigationController.pushViewController(homeViewController, animated: false)
	}

	func navigateToImageDetails(hit: Hit) {
		let imageDetailsViewController = ImageDetailsViewController.instantiate { coder -> ImageDetailsViewController in
			let imageDownloader: ImageDownloader = Resolver.resolve()
			let homeViewModel = ImageDetailsViewModel(hit: hit, imageDownloader: imageDownloader)
			return ImageDetailsViewController(coder: coder, viewModel: homeViewModel)!
		}

		navigationController.pushViewController(imageDetailsViewController, animated: true)
	}
}

extension Reactive where Base: HomeCoordinator
{
	var navigateToImageDetails: Binder<Hit> {
		Binder(self.base) { component, hit in
			component.navigateToImageDetails(hit: hit)
		}
	}
}
