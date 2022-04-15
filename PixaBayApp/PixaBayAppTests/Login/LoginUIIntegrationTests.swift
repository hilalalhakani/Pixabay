//
//  LoginUIIntegrationTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 06/03/2022.
//

import XCTest
import UIKit
import RxSwift
@testable import RegistrationPresentation
@testable import RegistrationNetwork

class LoginUIIntegrationTests: XCTestCase {
	func test_login_hasTitle() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, "Login")
	}

	func test_login_loginButtonIsDisabled() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertFalse(sut.isLoginButtonEnabled)
	}

	func test_login_registrationButtonIsEnabled() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertTrue(sut.isRegistrationButtonEnabled)
	}

	func test_insertText_InvalidUserNameInvalidPassword() {
		let (sut, _) = makeSUT()
		sut.loadViewIfNeeded()

		sut.insertEmail(email: invalidEmail())
		sut.insertPass(pass: invalidPassword())

		XCTAssertFalse(sut.isLoginButtonEnabled)
	}

	func test_insertText_InvalidUserNameValidPassword() {
		let (sut, _) = makeSUT()
		sut.loadViewIfNeeded()

		sut.insertEmail(email: invalidEmail())
		sut.insertPass(pass: validPassword())

		XCTAssertFalse(sut.isLoginButtonEnabled)
	}

	func test_insertText_validUserNameInvalidPassword() {
		let (sut, _) = makeSUT()
		sut.loadViewIfNeeded()

		sut.insertEmail(email: validEmail())
		sut.insertPass(pass: invalidPassword())

		XCTAssertFalse(sut.isLoginButtonEnabled)
	}

	func test_insertText_validUserNameValidPassword() {
		let (sut, _) = makeSUT()
		sut.loadViewIfNeeded()

		sut.insertEmail(email: validEmail())
		sut.insertPass(pass: validPassword())

		XCTAssertTrue(sut.isLoginButtonEnabled)
	}

	func test_registerButtonPressed_navigateToRegistrationOutputIsTriggered() {
		let (sut, _) = makeSUT()
		sut.loadViewIfNeeded()

		let navigateToHomeSpy = StateSpy<Void>(observable: sut.rx.navigateToRegistration.asObservable())
		sut.tapOnRegisterButton()

		XCTAssertEqual(navigateToHomeSpy.values.count, 1)

		sut.tapOnRegisterButton()
		XCTAssertEqual(navigateToHomeSpy.values.count, 2)

		sut.tapOnRegisterButton()
		XCTAssertEqual(navigateToHomeSpy.values.count, 3)
	}

	func test_loginButtonPressed_presentErrorOnIncorrectCredentials()
	{
		let (sut, vm) = makeSUT()
		sut.loadViewIfNeeded()
		let errorObservable = StateSpy<String>(observable: vm.output.error.asObservable())

		sut.insertEmail(email: validEmail())
		sut.insertPass(pass: validPassword())

		sut.tapOnLoginButton()

		XCTAssertEqual(errorObservable.values, ["Incorrect credentials"])
	}

	func test_loginButtonPressed_navigateToHomeOnCorrectCredentials()
	{
		let (sut, vm) = makeSUT()
		sut.loadViewIfNeeded()
		let navigateToHomeObservable = StateSpy<Void>(observable: vm.output.navigateToHome.asObservable())

		sut.insertEmail(email: "test@mail.com")
		sut.insertPass(pass: "123456")
		sut.tapOnLoginButton()

		XCTAssertEqual(navigateToHomeObservable.values.count, 1)
	}

	func test_loadingIndicator()
	{
		let (sut, vm) = makeSUT()
		sut.loadViewIfNeeded()
		let loadingObservable = StateSpy<Bool>(observable: vm.output.isLoading.asObservable())

		sut.insertEmail(email: "@mail.com")
		sut.insertPass(pass: "123456")
		sut.tapOnLoginButton()

		XCTAssertEqual(loadingObservable.values, [true, false])

		sut.insertEmail(email: "test@mail.com")
		sut.tapOnLoginButton()

		XCTAssertEqual(loadingObservable.values, [true, false, true, false])
	}

	// MARK: - Helpers

	private func validPassword() -> String {
		return "123456789"
	}

	private func validEmail() -> String {
		return "anyemail@test.com"
	}

	private func invalidPassword() -> String {
		return "123"
	}

	private func invalidEmail() -> String {
		return "invalidEmail"
	}

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: LoginViewController, vm: LoginViewModel) {
		let loginVM = LoginViewModel(userRepository: UserRepositoryMock())
		let loginVC = LoginViewController.instantiate { coder in
			LoginViewController(loginViewModel: loginVM, coder: coder)
		}
		trackForMemoryLeaks(loginVM, file: file, line: line)
		trackForMemoryLeaks(loginVC, file: file, line: line)
		return (loginVC, loginVM)
	}
}

extension LoginViewController {
	public var isLoginButtonEnabled: Bool
	{
		self.loginButton.isEnabled
	}

	public var isRegistrationButtonEnabled: Bool
	{
		self.signUpButton.isEnabled
	}

	public func insertEmail(email: String)
	{
		self.emailTextField.text = email
		self.emailTextField.sendActions(for: .valueChanged)
	}

	public func insertPass(pass: String)
	{
		self.passTextField.text = pass
		self.passTextField.sendActions(for: .valueChanged)
	}

	public func tapOnRegisterButton()
	{
		self.signUpButton.sendActions(for: .touchUpInside)
	}

	public func tapOnLoginButton()
	{
		self.loginButton.sendActions(for: .touchUpInside)
	}
}
