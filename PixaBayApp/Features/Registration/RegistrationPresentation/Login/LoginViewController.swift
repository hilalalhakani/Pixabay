//
//  ViewController.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import RxCocoa
import RxSwift
import UIKit
import SharedUI

public class LoginViewController: UIViewController, Storyboarded {
	// MARK: Outlets
	@IBOutlet public var emailTextField: EmailTextField!
	@IBOutlet public var passTextField: PasswordTextField!
	@IBOutlet public var loginButton: UIButton!
	@IBOutlet public var signUpButton: UIButton!
	@IBOutlet public var scrollView: UIScrollView!

	// MARK: Properties
	let disposeBag = DisposeBag()
	fileprivate let loginViewModel: LoginViewModel

	//MARK: Initialization
	public init?(loginViewModel: LoginViewModel, coder: NSCoder) {
		self.loginViewModel = loginViewModel
		super.init(coder: coder)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: LifeCycle

extension LoginViewController {
	override public func viewDidLoad() {
		super.viewDidLoad()
		setupBinding()
	}
}

//MARK: Helpers

extension LoginViewController {
	private func setupBinding() {
		Observable.combineLatest(emailTextField.isValid, passTextField.isValid)
			.map { $0.0 && $0.1 }
			.bind(to: loginButton.rx.isEnabled)
			.disposed(by: disposeBag)

		emailTextField.rx.text.orEmpty
			.bind(to: loginViewModel.input.email)
			.disposed(by: disposeBag)

		passTextField.rx.text.orEmpty
			.bind(to: loginViewModel.input.password)
			.disposed(by: disposeBag)

		loginButton.rx.tap
			.bind(to: loginViewModel.input.loginButtonTap)
			.disposed(by: disposeBag)

		signUpButton.rx.tap
			.bind(to: loginViewModel.input.registerButtonTap)
			.disposed(by: disposeBag)

		loginViewModel.output.isLoading
			.drive(rx.shouldLoadSVProgressHUD)
			.disposed(by: disposeBag)

		loginViewModel.output.error
			.drive(rx.shouldPresentError)
			.disposed(by: disposeBag)

		Keyboard.height()
			.drive(scrollView.rx.bindToScrollViewEdgeInsets)
			.disposed(by: disposeBag)
	}
}

public extension Reactive where Base: LoginViewController {
	var navigateToRegistration: Driver<Void> {
		base.loginViewModel.output.navigateToRegister
	}

	var navigateToHome: Driver<Void> {
		base.loginViewModel.output.navigateToHome
	}
}
