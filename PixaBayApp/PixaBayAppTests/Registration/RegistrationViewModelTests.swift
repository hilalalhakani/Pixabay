//
//  LoginViewModelTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 10/03/2022.
//

import XCTest
import UIKit
import RxSwift
@testable import RegistrationPresentation
@testable import RegistrationNetwork

class RegistrationViewModelTests: XCTestCase
{
	func test_isLoading()
	{
		let sut = makeSUT()
		let loaderObservableSpy = StateSpy<Bool>(observable: sut.output.isLoading.asObservable())

		sut.input.email.onNext("test@mail.com")
		sut.input.password.onNext("123456")
		sut.input.registerButtonPressed.onNext(())

		XCTAssertEqual(loaderObservableSpy.values, [true])
	}

	func test_navigationToHome()
	{
		let sut = makeSUT()
		let navigateToHomeSpy = StateSpy<Void>(observable: sut.output.navigateToHome.asObservable())

		sut.input.email.onNext("test22@mail.com")
		sut.input.password.onNext("123456")
		sut.input.age.onNext("30")

		sut.input.registerButtonPressed.onNext(())

		XCTAssertEqual(navigateToHomeSpy.values.count, 1)
	}

	func test_errorReceivedOnIncorrectCredentials()
	{
		let sut = makeSUT()
		let errorSpy = StateSpy<String>(observable: sut.output.error.asObservable())

		sut.input.email.onNext("test@mail.com")
		sut.input.password.onNext("123456")
		sut.input.age.onNext("30")
		sut.input.registerButtonPressed.onNext(())

		XCTAssertEqual(errorSpy.values, ["User already Exists"])
	}

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> RegistrationViewModel {
		let loginVM = RegistrationViewModel(userRepository: UserRepositoryMock())
		trackForMemoryLeaks(loginVM, file: file, line: line)
		return loginVM
	}
}
