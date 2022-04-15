//
//  LoginCoordinatorTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 12/04/2022.
//

import XCTest
@testable import PixaBayApp
import RegistrationPresentation
import HomePresentation

class RegistrationCoordinatorTests: XCTestCase {
	func test_start_LoginIsInitialViewController()
	{
		let (sut, _) = makeSUT()

		XCTAssertTrue(sut.navigationController.topViewController is LoginViewController)
	}

	func test_goRegistration_RegistrationBecomesTopViewController()
	{
		let (sut, _) = makeSUT()

		sut.navigateToRegistration()

		RunLoop.main.run(until: Date())
		XCTAssertTrue(sut.navigationController.topViewController is RegistrationViewController)
	}

	func test_goToHome_HomeBecomesTopViewController()
	{
		let (sut, mainCoordinator) = makeSUT()

		sut.navigateToHome()

		RunLoop.main.run(until: Date())

		XCTAssertEqual(mainCoordinator.childCoordinators.count, 1)
		XCTAssertTrue(mainCoordinator.navigationController.topViewController is HomeViewController)
	}

	func makeSUT() -> (loginCoordinator: LoginCoordinator, parentCoordinator: MainCoordinator)
	{
		let window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		let parentCoordinator = MainCoordinator(window: window, navigationController: navigationController)
		parentCoordinator.start()
		let loginCoordinator = parentCoordinator.childCoordinators.first as! LoginCoordinator
		trackForMemoryLeaks(loginCoordinator)
		trackForMemoryLeaks(parentCoordinator)
		return (loginCoordinator: loginCoordinator, parentCoordinator: parentCoordinator)
	}
}
