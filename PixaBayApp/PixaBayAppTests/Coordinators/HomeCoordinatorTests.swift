//
//  HomeCoordinatorTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 12/04/2022.
//

import XCTest
import HomePresentation
import HomeNetwork
import HomeDetailsPresentation
@testable import PixaBayApp

class HomeCoordinatorTests: XCTestCase
{
	func test_start_LoginIsInitialViewController()
	{
		let sut = makeSUT()

		XCTAssertTrue(sut.navigationController.topViewController is HomeViewController)
	}

	func test_goRegistration_RegistrationBecomesTopViewController()
	{
		let sut = makeSUT()

		sut.navigateToImageDetails(hit: makeHit())

		RunLoop.main.run(until: Date())
		XCTAssertTrue(sut.navigationController.topViewController is ImageDetailsViewController)
	}

	//MARK: Helpers
	func makeSUT() -> HomeCoordinator
	{
		let window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		let parentCoordinator = MainCoordinator(window: window, navigationController: navigationController)
		parentCoordinator.navigateToHome()
		let homeCoordinator = parentCoordinator.childCoordinators.first as! HomeCoordinator
		trackForMemoryLeaks(homeCoordinator)
		trackForMemoryLeaks(homeCoordinator)
		return homeCoordinator
	}

	private func makeHit() -> Hit
	{
		Hit(id: Int.random(in: 0 ... 1000),
		    pageURL: "pageURL",
		    type: "Type",
		    tags: "Tags",
		    previewURL: "",
		    previewWidth: Int.random(in: 0 ... 1000),
		    previewHeight: 0, webformatURL: "",
		    webformatWidth: Int.random(in: 0 ... 10000),
		    webformatHeight: Int.random(in: 0 ... 10000),
		    largeImageURL: "test.com",
		    imageWidth: Int.random(in: 0 ... 1000),
		    imageHeight: Int.random(in: 0 ... 1000),
		    imageSize: Int.random(in: 0 ... 10000),
		    views: 200,
		    downloads: Int.random(in: 0 ... 10000),
		    collections: Int.random(in: 0 ... 100000),
		    likes: 10,
		    comments: 3330,
		    userID: 0,
		    user: "UserName",
		    userImageURL: "1000")
	}
}
