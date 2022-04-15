//
//  MainCoordinatorTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 12/04/2022.
//

import XCTest
@testable import PixaBayApp
import RegistrationPresentation
import HomePresentation

class MainCoordinatorTests: XCTestCase {
	func test_start_LoginIsInitialViewController()
	{
		let sut = makeSUT()

		sut.start()

		XCTAssertTrue(sut.navigationController.topViewController is LoginViewController)
		XCTAssertEqual(sut.childCoordinators.count, 1)
	}

	func test_goToHome_HomeIsInitialViewController()
	{
		let sut = makeSUT()

		sut.start()
		sut.navigateToHome()

		XCTAssertTrue(sut.navigationController.topViewController is HomeViewController)
		XCTAssertEqual(sut.childCoordinators.count, 1)
	}

	func makeSUT() -> MainCoordinator
	{
		let window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		let mainCoordinator = MainCoordinator(window: window, navigationController: navigationController)
		trackForMemoryLeaks(mainCoordinator)
		return mainCoordinator
	}
}
