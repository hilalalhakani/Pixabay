//
//  RegistrationUIIntegrationTests.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 13/03/2022.
//

import XCTest
import UIKit
import RxSwift
@testable import RegistrationPresentation
@testable import RegistrationNetwork

class RegistrationUIIntegrationTests: XCTestCase {
	func test_registration_hasTitle() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, "Registration")
	}

	func test_register_registerButtonIsDisabled() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertFalse(sut.signUpButton.isEnabled)
	}

	func test_Validation_InvalidEmailAndInvalidPassAndInvalidAge_RegisterButtonDisabled() {
		insertText(email: "InvalidEmail", password: "12", age: "1", expectedResult: false)
	}

	func test_Validation_InvalidEmailAndInvalidPassAndValidAge_RegisterButtonDisabled() {
		insertText(email: "InvalidEmail", password: "12", age: "20", expectedResult: false)
	}

	func test_Validation_InValidEmailAndValidPassAndInvalidAge_RegisterButtonDisabled() {
		insertText(email: "InvalidEmail", password: "123456789", age: "1", expectedResult: false)
	}

	func test_Validation_InvalidEmailAndValidPassAndValidAge_RegisterButtonDisabled() {
		insertText(email: "InvalidEmail", password: "123456789", age: "18", expectedResult: false)
	}

	func test_Validation_ValidEmailAndInvalidPassAndInvalidAge_RegisterButtonDisabled() {
		insertText(email: "hilal@mail.com", password: "12", age: "1", expectedResult: false)
	}

	func test_Validation_ValidEmailAndInvalidPassAndValidAge_RegisterButtonDisabled() {
		insertText(email: "hilal@mail.com", password: "12", age: "20", expectedResult: false)
	}

	func test_Validation_ValidEmailAndInValidPassAndInvalidAge_RegisterButtonDisabled() {
		insertText(email: "hilal@mail.com", password: "123456789", age: "1", expectedResult: false)
	}

	func test_Validation_ValidEmailAndValidPassAndValidAge_RegisterButtonEnabled() {
		insertText(email: "hilal@mail.com", password: "123456789", age: "18", expectedResult: true)
	}

	func test_registerButtonPressed_navigateToHomeOnCorrectCredentials()
	{
		let (sut, vm) = makeSUT()
		sut.loadViewIfNeeded()

		let navigateToHomeObservable = StateSpy<Void>(observable: vm.output.navigateToHome.asObservable())

		sut.insertEmail(email: "anyEmail@mail.com")
		sut.insertPass(pass: "123456")
		sut.insertAge(age: "25")

		sut.tapOnRegisterButton()

		XCTAssertEqual(navigateToHomeObservable.values.count, 1)
	}

	func test_registerButtonPressed_withAnAlreadyExistingEmail()
	{
		let (sut, vm) = makeSUT()
		sut.loadViewIfNeeded()

		let navigateToHomeObservable = StateSpy<Void>(observable: vm.output.navigateToHome.asObservable())

		sut.insertEmail(email: "test@mail.com")
		sut.insertPass(pass: "123456")
		sut.insertAge(age: "25")

		sut.tapOnRegisterButton()

		XCTAssertEqual(navigateToHomeObservable.values.count, 0)
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

	private func invalidAge() -> String {
		return "2"
	}

	private func validAge() -> String {
		return "30"
	}

	func insertText(email: String, password: String, age: String, expectedResult: Bool, file: StaticString = #file, line: UInt = #line) {
		let sut = makeSUT()
		let vc = sut.vc
		vc.loadViewIfNeeded()

		vc.insertEmail(email: email)
		vc.insertPass(pass: password)
		vc.insertAge(age: age)
		XCTAssertEqual(vc.isRegistrationButtonEnabled, expectedResult)
	}

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (vc: RegistrationViewController, vm: RegistrationViewModel) {
		let vm = RegistrationViewModel(userRepository: UserRepositoryMock())
		let vc = RegistrationViewController.instantiate { coder in
			RegistrationViewController(coder: coder, viewModel: vm)
		}
		trackForMemoryLeaks(vm, file: file, line: line)
		trackForMemoryLeaks(vc, file: file, line: line)
		return (vc, vm)
	}
}

extension RegistrationViewController
{
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

	public func insertAge(age: String)
	{
		self.ageTextField.text = age
		self.ageTextField.sendActions(for: .valueChanged)
	}

	public func tapOnRegisterButton()
	{
		self.signUpButton.sendActions(for: .touchUpInside)
	}
}
