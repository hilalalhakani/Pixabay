//
//  RegistrationSnapshotTest.swift
//  PixBaySnapshotsTests
//
//  Created by Pinpay Graphic on 17/10/2021.
//

import XCTest
import RegistrationPresentation
import RegistrationNetwork
import SharedUI

class RegistrationSnapshotsTests: XCTestCase {
	func test_LoginScreen() {
		let sut = makeSUT()
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "RegistrationScreen_light")
		assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "RegistrationScreen_dark")
	}

	// MARK: - Helpers
	private func makeSUT() -> RegistrationViewController {
		let controller = RegistrationViewController.instantiate { coder in
			return RegistrationViewController(coder: coder, viewModel: RegistrationViewModel(userRepository: UserRepositoryMock()))
		}
		controller.loadViewIfNeeded()
		return controller
	}
}
