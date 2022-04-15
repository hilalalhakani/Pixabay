//
//  PixBaySnapshotsTests.swift
//  PixBaySnapshotsTests
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import XCTest
import RegistrationPresentation
import RegistrationNetwork
import SharedUI

class LoginSnapshotsTests: XCTestCase {
	func test_LoginScreen() {
		let sut = makeSUT()
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LoginScreen_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LoginScreen_dark")
	}

	// MARK: - Helpers

	private func makeSUT() -> LoginViewController {
		let controller = LoginViewController.instantiate { coder in
			return LoginViewController(loginViewModel: LoginViewModel(userRepository: UserRepositoryMock()), coder: coder)
		}
		controller.loadViewIfNeeded()
		return controller
	}
}
