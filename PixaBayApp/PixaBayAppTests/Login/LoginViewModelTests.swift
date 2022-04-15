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

class LoginViewModelTests: XCTestCase
{
	func test_loginBtnPress()
	{
		let sut = makeSUT()
		let navigateToRegistrationObservable = StateSpy<Void>(observable: sut.output.navigateToRegister.asObservable())

		sut.input.registerButtonTap.onNext(())

		XCTAssertEqual(navigateToRegistrationObservable.values.count, 1)
	}

	func test_isLoading()
	{
		let sut = makeSUT()
		let loaderObservableSpy = StateSpy<Bool>(observable: sut.output.isLoading.asObservable())

		sut.input.email.onNext("test@mail.com")
		sut.input.password.onNext("123456")
		sut.input.loginButtonTap.onNext(())

		XCTAssertEqual(loaderObservableSpy.values, [true, false])
	}

	func test_navigationToHome()
	{
		let sut = makeSUT()
		let navigateToHomeSpy = StateSpy<Void>(observable: sut.output.navigateToHome.asObservable())

		sut.input.email.onNext("test@mail.com")
		sut.input.password.onNext("123456")
		sut.input.loginButtonTap.onNext(())

		XCTAssertEqual(navigateToHomeSpy.values.count, 1)
	}

	func test_errorReceivedOnIncorrectCredentials()
	{
		let sut = makeSUT()
		let errorSpy = StateSpy<String>(observable: sut.output.error.asObservable())

		sut.input.email.onNext("IncorrectEmail@mail.com")
		sut.input.password.onNext("123456")
		sut.input.loginButtonTap.onNext(())

		XCTAssertEqual(errorSpy.values, ["Incorrect credentials"])
	}

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> LoginViewModel {
		let loginVM = LoginViewModel(userRepository: UserRepositoryMock())
		trackForMemoryLeaks(loginVM, file: file, line: line)
		return loginVM
	}
}
